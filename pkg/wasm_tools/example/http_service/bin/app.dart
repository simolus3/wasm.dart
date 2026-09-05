import 'dart:async';
import 'dart:convert';

import 'package:wasi/src/components/wasi_http_service.dart';
import 'package:wasi/src/components/wasi_http.dart';
import 'package:wasm_components/wasm_components.dart';

void main() {
  serviceComponent((imports) => _RequestHandler(imports));
}

final class _RequestHandler(final ServiceImports _imports) implements Handler {
  var _requestId = 0;

  @override
  Future<Result<Owned<TypesResponse>, TypesErrorCode>> handle({
    required Owned<TypesRequest> request,
  }) async {
    final headers = _imports.httpTypes.constructorFields();

    final responseText =
        '''
<!doctype html>
<html>
<head>
  <title>dart2wasm http server</title>
</head>
<body>
<h1>This website is running Dart!</h1>

<p>
Okay, that alone wouldn't be to impressive. But it's also running in <em>wasmtime</em>!
</p<>

<p>
This is request number ${_requestId++} served by this server.
</p>
</body>
</html>
''';

    final (response, _) = _imports.httpTypes.staticResponseNew(
      headers: headers,
      contents: .some(.value(utf8.encode(responseText))),
      trailers: Future.syncValue(.ok(.none)),
    );

    request.drop();
    return .ok(response);
  }
}
