/// A `package:http` [http.Client] backed by `wasi:http/client@0.3.0`.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:wasm_components/wasm_components.dart';

import '../src/components/wasi_http.dart';
import '../src/components/wasi_http_service.dart';

/// An [http.BaseClient] that sends outbound HTTP requests over
/// `wasi:http/client@0.3.0`.
final class WasiHttpClient extends http.BaseClient {
  final Client _client;
  final Types _types;
  var _isClosed = false;

  /// Creates a [WasiHttpClient] using the `wasi:http` imports from a
  /// `wasi:http/service` world's [ServiceImports].
  WasiHttpClient(ServiceImports imports)
    : _client = imports.httpClient,
      _types = imports.httpTypes;

  /// Creates a [WasiHttpClient] from explicit `wasi:http/client` and
  /// `wasi:http/types` imports.
  WasiHttpClient.fromImports({required Client client, required Types types})
    : this._(client, types);

  /// Creates a [WasiHttpClient] that routes requests directly to an in-process
  /// or composed `wasi:http/handler` [Handler] without going over the network.
  WasiHttpClient.fromHandler({required Handler handler, required Types types})
    : this._(_HandlerAsClient(handler), types);

  WasiHttpClient._(this._client, this._types);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (_isClosed) {
      throw http.ClientException(
        'HTTP request failed. Client is already closed.',
        request.url,
      );
    }

    if (!request.url.hasScheme || !request.url.hasAuthority) {
      throw http.ClientException(
        'Request URL must include a scheme and authority: ${request.url}',
        request.url,
      );
    }

    final byteStream = request.finalize();

    final requestFields = _types.constructorFields();
    final requestFieldsBorrow = requestFields.borrow();
    for (final MapEntry(key: name, :value) in request.headers.entries) {
      final lower = name.toLowerCase();
      // WASI HTTP forbids connection-specific hop-by-hop headers and manages
      // Host via request.set-authority.
      if (lower == 'host' ||
          lower == 'connection' ||
          lower == 'keep-alive' ||
          lower == 'transfer-encoding' ||
          lower == 'upgrade' ||
          lower == 'te' ||
          lower == 'trailer' ||
          lower == 'proxy-authenticate' ||
          lower == 'proxy-authorization') {
        continue;
      }
      if (_types.methodFieldsAppend(
            self: requestFieldsBorrow,
            name: name,
            value: utf8.encode(value),
          )
          case ErrorResult(:final value)) {
        requestFields.drop();
        throw http.ClientException(
          'Invalid HTTP header "$name": $value',
          request.url,
        );
      }
    }

    final Option<Stream<Uint8List>> contents;
    if (request.contentLength == 0) {
      unawaited(byteStream.drain<void>());
      contents = Option.none;
    } else {
      final bodyStream = byteStream.map(
        (chunk) => chunk is Uint8List ? chunk : Uint8List.fromList(chunk),
      );
      contents = Option.some(bodyStream);
    }

    final (wasiRequest, transmitFuture) = _types.staticRequestNew(
      headers: requestFields,
      contents: contents,
      trailers: Future.syncValue(const Result.ok(Option.none)),
      options: Option.none,
    );
    transmitFuture.ignore();

    final reqBorrow = wasiRequest.borrow();
    if (_types.methodRequestSetMethod(
          self: reqBorrow,
          method: _toWasiMethod(request.method),
        )
        case ErrorResult()) {
      wasiRequest.drop();
      throw http.ClientException(
        'Invalid HTTP method: ${request.method}',
        request.url,
      );
    }

    if (_types.methodRequestSetScheme(
          self: reqBorrow,
          scheme: Option.some(_toWasiScheme(request.url.scheme)),
        )
        case ErrorResult()) {
      wasiRequest.drop();
      throw http.ClientException(
        'Invalid URI scheme: ${request.url.scheme}',
        request.url,
      );
    }

    if (_types.methodRequestSetAuthority(
          self: reqBorrow,
          authority: Option.some(request.url.authority),
        )
        case ErrorResult()) {
      wasiRequest.drop();
      throw http.ClientException(
        'Invalid URI authority: ${request.url.authority}',
        request.url,
      );
    }

    final path = request.url.path.isEmpty ? '/' : request.url.path;
    final pathWithQuery = request.url.hasQuery
        ? '$path?${request.url.query}'
        : path;
    if (_types.methodRequestSetPathWithQuery(
          self: reqBorrow,
          pathWithQuery: Option.some(pathWithQuery),
        )
        case ErrorResult()) {
      wasiRequest.drop();
      throw http.ClientException(
        'Invalid URI path/query: $pathWithQuery',
        request.url,
      );
    }

    final sendResult = await _client.send(request: wasiRequest);
    final Owned<TypesResponse> wasiResponse;
    switch (sendResult) {
      case OkResult(:final value):
        wasiResponse = value;
      case ErrorResult(value: final error):
        throw http.ClientException(
          'WASI HTTP error (${_describeErrorCode(error)})',
          request.url,
        );
    }

    final respBorrow = wasiResponse.borrow();
    final statusCode = _types.methodResponseGetStatusCode(self: respBorrow);

    final rawHeadersOwned = _types.methodResponseGetHeaders(self: respBorrow);
    final rawHeaderPairs = _types.methodFieldsCopyAll(
      self: rawHeadersOwned.borrow(),
    );
    rawHeadersOwned.drop();

    final responseHeaders = <String, String>{};
    for (final (name, bytes) in rawHeaderPairs) {
      final key = name.toLowerCase();
      final value = utf8.decode(bytes, allowMalformed: true);
      final existing = responseHeaders[key];
      responseHeaders[key] = existing == null ? value : '$existing, $value';
    }

    final responseResCompleter = Completer<Result<void, TypesErrorCode>>();
    final (rawBodyStream, responseTrailers) = _types.staticResponseConsumeBody(
      $this: wasiResponse,
      res: responseResCompleter.future,
    );

    void finishResponse() {
      if (!responseResCompleter.isCompleted) {
        responseResCompleter.complete(const Result.ok(null));
      }
    }

    final responseBodyStream = _trackStreamCompletion(
      rawBodyStream,
      responseTrailers,
      request.url,
      finishResponse,
    );

    final contentLengthHeader = responseHeaders['content-length'];
    final contentLength = contentLengthHeader != null
        ? int.tryParse(contentLengthHeader)
        : null;

    return http.StreamedResponse(
      responseBodyStream,
      statusCode,
      contentLength: contentLength,
      request: request,
      headers: responseHeaders,
    );
  }

  @override
  void close() {
    _isClosed = true;
    super.close();
  }
}

final class _HandlerAsClient implements Client {
  final Handler _handler;

  const _HandlerAsClient(this._handler);

  @override
  Future<Result<Owned<TypesResponse>, TypesErrorCode>> send({
    required Owned<TypesRequest> request,
  }) => _handler.handle(request: request);
}

Stream<List<int>> _trackStreamCompletion(
  Stream<Uint8List> source,
  Future<Result<Option<Owned<TypesFields>>, TypesErrorCode>> responseTrailers,
  Uri requestUrl,
  void Function() onFinish,
) {
  // Prevent unhandled async errors if responseTrailers rejects before onDone
  // awaits it or if the stream is never listened to.
  responseTrailers.ignore();

  StreamSubscription<Uint8List>? subscription;
  late final StreamController<List<int>> controller;
  controller = StreamController<List<int>>(
    sync: true,
    onListen: () {
      subscription = source.listen(
        controller.add,
        onError: controller.addError,
        onDone: () async {
          try {
            final trailersRes = await responseTrailers;
            switch (trailersRes) {
              case OkResult(value: final opt):
                if (opt.hasValue) {
                  opt.requireValue().drop();
                }
              case ErrorResult(value: final error):
                if (!controller.isClosed) {
                  controller.addError(
                    http.ClientException(
                      'WASI HTTP response body error (${_describeErrorCode(error)})',
                      requestUrl,
                    ),
                  );
                }
            }
          } on RemoteEndDroppedException {
            // Host dropped trailers future cleanly without trailers.
          } catch (e, st) {
            if (!controller.isClosed) {
              controller.addError(e, st);
            }
          } finally {
            onFinish();
            if (!controller.isClosed) {
              await controller.close();
            }
          }
        },
      );
    },
    onPause: () => subscription?.pause(),
    onResume: () => subscription?.resume(),
    onCancel: () {
      onFinish();
      unawaited(
        responseTrailers.then((res) {
          if (res case OkResult(value: final opt) when opt.hasValue) {
            opt.requireValue().drop();
          }
        }, onError: (_) {}),
      );
      return subscription?.cancel();
    },
  );
  return controller.stream;
}

TypesMethod _toWasiMethod(String method) => switch (method.toUpperCase()) {
  'GET' => const TypesMethod.get(),
  'HEAD' => const TypesMethod.head(),
  'POST' => const TypesMethod.post(),
  'PUT' => const TypesMethod.put(),
  'DELETE' => const TypesMethod.delete(),
  'CONNECT' => const TypesMethod.connect(),
  'OPTIONS' => const TypesMethod.options(),
  'TRACE' => const TypesMethod.trace(),
  'PATCH' => const TypesMethod.patch(),
  _ => TypesMethod.other(method),
};

TypesScheme _toWasiScheme(String scheme) => switch (scheme.toLowerCase()) {
  'http' => const TypesScheme.http(),
  'https' => const TypesScheme.https(),
  final other => TypesScheme.other(other),
};

String _describeErrorCode(TypesErrorCode error) => switch (error) {
  TypesErrorCodeDnsTimeout() => 'dns-timeout',
  TypesErrorCodeDnsError(:final payload) =>
    'dns-error(rcode: ${payload.rcode}, infoCode: ${payload.infoCode})',
  TypesErrorCodeDestinationNotFound() => 'destination-not-found',
  TypesErrorCodeDestinationUnavailable() => 'destination-unavailable',
  TypesErrorCodeDestinationIpProhibited() => 'destination-ip-prohibited',
  TypesErrorCodeDestinationIpUnroutable() => 'destination-ip-unroutable',
  TypesErrorCodeConnectionRefused() => 'connection-refused',
  TypesErrorCodeConnectionTerminated() => 'connection-terminated',
  TypesErrorCodeConnectionTimeout() => 'connection-timeout',
  TypesErrorCodeConnectionReadTimeout() => 'connection-read-timeout',
  TypesErrorCodeConnectionWriteTimeout() => 'connection-write-timeout',
  TypesErrorCodeConnectionLimitReached() => 'connection-limit-reached',
  TypesErrorCodeTlsProtocolError() => 'tls-protocol-error',
  TypesErrorCodeTlsCertificateError() => 'tls-certificate-error',
  TypesErrorCodeTlsAlertReceived(:final payload) =>
    'tls-alert-received(id: ${payload.alertId}, msg: ${payload.alertMessage})',
  TypesErrorCodeHttpRequestDenied() => 'http-request-denied',
  TypesErrorCodeHttpRequestLengthRequired() => 'http-request-length-required',
  TypesErrorCodeHttpRequestBodySize(:final payload) =>
    'http-request-body-size($payload)',
  TypesErrorCodeHttpRequestMethodInvalid() => 'http-request-method-invalid',
  TypesErrorCodeHttpRequestUriInvalid() => 'http-request-uri-invalid',
  TypesErrorCodeHttpRequestUriTooLong() => 'http-request-uri-too-long',
  TypesErrorCodeHttpRequestHeaderSectionSize(:final payload) =>
    'http-request-header-section-size($payload)',
  TypesErrorCodeHttpRequestHeaderSize(:final payload) =>
    'http-request-header-size($payload)',
  TypesErrorCodeHttpRequestTrailerSectionSize(:final payload) =>
    'http-request-trailer-section-size($payload)',
  TypesErrorCodeHttpRequestTrailerSize(:final payload) =>
    'http-request-trailer-size($payload)',
  TypesErrorCodeHttpResponseIncomplete() => 'http-response-incomplete',
  TypesErrorCodeHttpResponseHeaderSectionSize(:final payload) =>
    'http-response-header-section-size($payload)',
  TypesErrorCodeHttpResponseHeaderSize(:final payload) =>
    'http-response-header-size($payload)',
  TypesErrorCodeHttpResponseBodySize(:final payload) =>
    'http-response-body-size($payload)',
  TypesErrorCodeHttpResponseTrailerSectionSize(:final payload) =>
    'http-response-trailer-section-size($payload)',
  TypesErrorCodeHttpResponseTrailerSize(:final payload) =>
    'http-response-trailer-size($payload)',
  TypesErrorCodeHttpResponseTransferCoding(:final payload) =>
    'http-response-transfer-coding($payload)',
  TypesErrorCodeHttpResponseContentCoding(:final payload) =>
    'http-response-content-coding($payload)',
  TypesErrorCodeHttpResponseTimeout() => 'http-response-timeout',
  TypesErrorCodeHttpUpgradeFailed() => 'http-upgrade-failed',
  TypesErrorCodeHttpProtocolError() => 'http-protocol-error',
  TypesErrorCodeLoopDetected() => 'loop-detected',
  TypesErrorCodeConfigurationError() => 'configuration-error',
  TypesErrorCodeInternalError(:final payload) => 'internal-error($payload)',
};
