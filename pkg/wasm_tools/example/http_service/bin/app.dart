import 'dart:async';
import 'dart:convert';

import 'package:wasi/src/components/wasi_http_service.dart';
import 'package:wasi/src/components/wasi_http.dart';
import 'package:wasm_components/wasm_components.dart';

void main() {
  serviceComponent((imports) => _RequestHandler(imports));
}

final class _RequestHandler implements Handler {
  final ServiceImports _imports;

  new(this._imports);

  @override
  Future<Result<Owned<TypesResponse>, TypesErrorCode>> handle({
    required Owned<TypesRequest> request,
  }) async {
    final Owned<TypesFields> headers;
    switch (_imports.httpTypes.staticFieldsFromList(
      entries: [('X-Test', utf8.encode('Foo'))],
    )) {
      case OkResult(:final value):
        headers = value;
      case ErrorResult():
        return .error(
          .internalError(.some("Could not encode response headers")),
        );
    }

    final (response, _) = _imports.httpTypes.staticResponseNew(
      headers: headers,
      contents: .none,
      trailers: Future(() => .ok(.none)),
    );

    request.drop();
    return .ok(response);
  }
}
