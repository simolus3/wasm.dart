import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:shelf/shelf.dart' as shelf;
import 'package:wasi/http.dart';
// ignore: implementation_imports
import 'package:wasi/src/components/wasi_http_service.dart';
import 'package:wasm_components/wasm_components.dart';

/// Registers a [shelf.Handler] factory as the `wasi:http/service@0.3.0`
/// component export.
///
/// The [createHandler] callback is invoked inside `wasi:http/handler#handle`
/// rather than during the WebAssembly component `start` function (`_start`),
/// because the Component Model forbids calling host imports (such as
/// `wasi:random/insecure` when seeding Dart `HashMap` / `Object.hashCode`)
/// during module instantiation.
void serveWasiShelf(shelf.Handler Function() createHandler) {
  serviceComponent((imports) => _ShelfWasiHandler(imports, createHandler));
}

final class _ShelfWasiHandler implements Handler {
  final ServiceImports _imports;
  final shelf.Handler Function() _createHandler;
  shelf.Handler? _handler;

  _ShelfWasiHandler(this._imports, this._createHandler);

  @override
  Future<Result<Owned<TypesResponse>, TypesErrorCode>> handle({
    required Owned<TypesRequest> request,
  }) async {
    final httpTypes = _imports.httpTypes;
    try {
      final handler = _handler ??= _createHandler();
      final reqBorrow = request.borrow();

      final method = _mapMethod(
        httpTypes.methodRequestGetMethod(self: reqBorrow),
      );
      final schemeOpt = httpTypes.methodRequestGetScheme(self: reqBorrow);
      final scheme = schemeOpt.hasValue
          ? _mapScheme(schemeOpt.requireValue())
          : 'http';

      final rawHeadersOwned = httpTypes.methodRequestGetHeaders(
        self: reqBorrow,
      );
      final rawHeaderPairs = httpTypes.methodFieldsCopyAll(
        self: rawHeadersOwned.borrow(),
      );
      rawHeadersOwned.drop();

      final requestHeaders = <String, List<String>>{};
      String? hostHeader;
      for (final (name, bytes) in rawHeaderPairs) {
        final value = utf8.decode(bytes, allowMalformed: true);
        requestHeaders.putIfAbsent(name, () => <String>[]).add(value);
        if (hostHeader == null && name.toLowerCase() == 'host') {
          hostHeader = value;
        }
      }

      final authorityOpt = httpTypes.methodRequestGetAuthority(self: reqBorrow);
      final authority =
          (authorityOpt.hasValue && authorityOpt.requireValue().isNotEmpty)
          ? authorityOpt.requireValue()
          : (hostHeader != null && hostHeader.isNotEmpty)
          ? hostHeader
          : 'localhost';

      final pathWithQueryOpt = httpTypes.methodRequestGetPathWithQuery(
        self: reqBorrow,
      );
      var pathWithQuery =
          (pathWithQueryOpt.hasValue &&
              pathWithQueryOpt.requireValue().isNotEmpty)
          ? pathWithQueryOpt.requireValue()
          : '/';
      if (!pathWithQuery.startsWith('/')) {
        pathWithQuery = '/$pathWithQuery';
      }

      final requestedUri = Uri.parse('$scheme://$authority$pathWithQuery');

      final requestResCompleter = Completer<Result<void, TypesErrorCode>>();
      final (bodyStream, _) = httpTypes.staticRequestConsumeBody(
        $this: request,
        res: requestResCompleter.future,
      );

      var bodyListened = false;
      final trackedBodyStream = Stream<List<int>>.eventTransformed(bodyStream, (
        sink,
      ) {
        bodyListened = true;
        return sink;
      });

      final shelfRequest = shelf.Request(
        method,
        requestedUri,
        headers: requestHeaders,
        body: trackedBodyStream,
      );

      final shelf.Response shelfResponse;
      try {
        shelfResponse = await handler(shelfRequest);
      } catch (e) {
        if (!bodyListened) {
          unawaited(bodyStream.drain<void>());
        }
        requestResCompleter.complete(const Result.ok(null));
        return _errorResponse('Handler error: $e');
      }

      if (!bodyListened) {
        unawaited(bodyStream.drain<void>());
      }
      requestResCompleter.complete(const Result.ok(null));

      final responseFields = httpTypes.constructorFields();
      final responseFieldsBorrow = responseFields.borrow();
      shelfResponse.headersAll.forEach((name, values) {
        if (name.toLowerCase() == 'transfer-encoding') return;
        for (final value in values) {
          httpTypes.methodFieldsAppend(
            self: responseFieldsBorrow,
            name: name,
            value: utf8.encode(value),
          );
        }
      });

      final responseBodyStream = shelfResponse.read().map(
        (chunk) => chunk is Uint8List ? chunk : Uint8List.fromList(chunk),
      );

      final (wasiResponse, _) = httpTypes.staticResponseNew(
        headers: responseFields,
        contents: Option.some(responseBodyStream),
        trailers: Future.syncValue(const Result.ok(Option.none)),
      );

      if (shelfResponse.statusCode != 200) {
        httpTypes.methodResponseSetStatusCode(
          self: wasiResponse.borrow(),
          statusCode: shelfResponse.statusCode,
        );
      }

      return Result.ok(wasiResponse);
    } catch (e) {
      return _errorResponse('Outer WASI Shelf error: $e');
    }
  }

  Result<Owned<TypesResponse>, TypesErrorCode> _errorResponse(String message) {
    final httpTypes = _imports.httpTypes;
    final fields = httpTypes.constructorFields();
    final (resp, _) = httpTypes.staticResponseNew(
      headers: fields,
      contents: Option.some(Stream.value(utf8.encode('$message\n'))),
      trailers: Future.syncValue(const Result.ok(Option.none)),
    );
    httpTypes.methodResponseSetStatusCode(self: resp.borrow(), statusCode: 500);
    return Result.ok(resp);
  }
}

String _mapMethod(TypesMethod method) => switch (method) {
  TypesMethodGet() => 'GET',
  TypesMethodHead() => 'HEAD',
  TypesMethodPost() => 'POST',
  TypesMethodPut() => 'PUT',
  TypesMethodDelete() => 'DELETE',
  TypesMethodConnect() => 'CONNECT',
  TypesMethodOptions() => 'OPTIONS',
  TypesMethodTrace() => 'TRACE',
  TypesMethodPatch() => 'PATCH',
  TypesMethodOther(:final payload) => payload,
};

String _mapScheme(TypesScheme scheme) => switch (scheme) {
  TypesSchemeHttp() => 'http',
  TypesSchemeHttps() => 'https',
  TypesSchemeOther(:final payload) => payload,
};
