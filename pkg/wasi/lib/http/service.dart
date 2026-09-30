/// Define a component adhering to the `wasi:http/service` world.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:shelf/shelf.dart' as shelf;
import 'package:wasm_components/wasm_components.dart';

import '../http.dart';
import '../src/components/wasi_http_service.dart';

export '../src/components/wasi_http_service.dart'
    show serviceComponent, ServiceImports;
export 'client.dart' show WasiHttpClient;

/// Registers a [shelf.Handler] factory as the `wasi:http/service@0.3.0`
/// component export.
///
/// The [createHandler] callback receives the world's [ServiceImports] and is
/// invoked lazily inside `wasi:http/handler#handle` rather than during the
/// WebAssembly component `start` function (`_start`), because the Component
/// Model forbids calling host imports (such as `wasi:random/insecure` when
/// seeding Dart `HashMap` / `Object.hashCode`) during module instantiation.
void serveWasiShelf(
  shelf.Handler Function(ServiceImports imports) createHandler,
) {
  serviceComponent((imports) => _ShelfWasiHandler(imports, createHandler));
}

final class _ShelfWasiHandler implements Handler {
  final ServiceImports _imports;
  final shelf.Handler Function(ServiceImports imports) _createHandler;
  shelf.Handler? _handler;

  _ShelfWasiHandler(this._imports, this._createHandler);

  @override
  Future<Result<Owned<TypesResponse>, TypesErrorCode>> handle({
    required Owned<TypesRequest> request,
  }) async {
    final httpTypes = _imports.httpTypes;
    var requestConsumed = false;
    try {
      final handler = _handler ??= _createHandler(_imports);
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
      String? fallbackOriginAuthority;
      for (final (name, bytes) in rawHeaderPairs) {
        final value = utf8.decode(bytes, allowMalformed: true);
        requestHeaders.putIfAbsent(name, () => <String>[]).add(value);
        final lower = name.toLowerCase();
        if (hostHeader == null &&
            (lower == 'host' || lower == 'x-forwarded-host')) {
          hostHeader = value;
        } else if (fallbackOriginAuthority == null &&
            (lower == 'origin' || lower == 'referer')) {
          final parsed = Uri.tryParse(value);
          if (parsed != null && parsed.hasAuthority) {
            fallbackOriginAuthority = parsed.authority;
          }
        }
      }

      final authorityOpt = httpTypes.methodRequestGetAuthority(self: reqBorrow);
      final authority =
          (authorityOpt.hasValue && authorityOpt.requireValue().isNotEmpty)
          ? authorityOpt.requireValue()
          : (hostHeader != null && hostHeader.isNotEmpty)
          ? hostHeader
          : (fallbackOriginAuthority != null &&
                fallbackOriginAuthority.isNotEmpty)
          ? fallbackOriginAuthority
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
      final (bodyStream, requestTrailers) = httpTypes.staticRequestConsumeBody(
        $this: request,
        res: requestResCompleter.future,
      );
      requestConsumed = true;
      unawaited(
        requestTrailers.then((res) {
          if (res case OkResult(value: final opt) when opt.hasValue) {
            opt.requireValue().drop();
          }
        }, onError: (_) {}),
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

      final (wasiResponse, responseResult) = httpTypes.staticResponseNew(
        headers: responseFields,
        contents: Option.some(responseBodyStream),
        trailers: Future.syncValue(const Result.ok(Option.none)),
      );
      responseResult.ignore();

      if (shelfResponse.statusCode != 200) {
        httpTypes.methodResponseSetStatusCode(
          self: wasiResponse.borrow(),
          statusCode: shelfResponse.statusCode,
        );
      }

      return Result.ok(wasiResponse);
    } catch (e) {
      if (!requestConsumed) {
        request.drop();
      }
      return _errorResponse('Outer WASI Shelf error: $e');
    }
  }

  Result<Owned<TypesResponse>, TypesErrorCode> _errorResponse(String message) {
    final httpTypes = _imports.httpTypes;
    final fields = httpTypes.constructorFields();
    final (resp, responseResult) = httpTypes.staticResponseNew(
      headers: fields,
      contents: Option.some(Stream.value(utf8.encode('$message\n'))),
      trailers: Future.syncValue(const Result.ok(Option.none)),
    );
    responseResult.ignore();
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
