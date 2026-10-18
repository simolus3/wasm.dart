import 'dart:async';
import 'dart:convert';

import 'package:shelf/shelf.dart' as shelf;
import 'package:wasi/http/service.dart';

var _requestId = 0;

void main() {
  serveWasiShelf(
    (_) => const shelf.Pipeline()
        .addMiddleware(_wasiServerHeaderMiddleware)
        .addHandler(_router),
  );
}

shelf.Middleware get _wasiServerHeaderMiddleware => (innerHandler) {
  return (request) async {
    final response = await innerHandler(request);
    return response.change(
      headers: {
        'x-powered-by': 'dart2wasm + wasi:http/service@0.3.0 + package:shelf',
      },
    );
  };
};

FutureOr<shelf.Response> _router(shelf.Request request) =>
    switch ((request.method, request.url.pathSegments)) {
      ('GET', []) => shelf.Response.ok(
        '''
<!doctype html>
<html>
<head>
  <title>dart2wasm http server</title>
</head>
<body>
<h1>This website is running Dart + <code>package:shelf</code>!</h1>

<p>
Okay, that alone wouldn't be too impressive. But it's also running in <em>wasmtime</em>!
</p>

<p>
This is request number ${_requestId++} served by this instance.
</p>
</body>
</html>
''',
        headers: {'content-type': 'text/html; charset=utf-8'},
      ),
      ('GET', ['hello', final name]) => shelf.Response.ok(
        const JsonEncoder.withIndent('  ').convert({
          'greeting': 'Hello, ${Uri.decodeComponent(name)}!',
          'runtime': 'wasmtime (wasi:http/service@0.3.0)',
          'framework': 'package:shelf',
          'path': request.requestedUri.path,
          'query': request.requestedUri.queryParameters,
        }),
        headers: {'content-type': 'application/json; charset=utf-8'},
      ),
      ('POST', ['echo']) => _handleEcho(request),
      _ => shelf.Response.notFound('Not found\n'),
    };

Future<shelf.Response> _handleEcho(shelf.Request request) async {
  final body = await request.readAsString(utf8);
  return shelf.Response.ok(
    const JsonEncoder.withIndent('  ').convert({
      'echoedMethod': request.method,
      'echoedPath': request.requestedUri.path,
      'echoedQuery': request.requestedUri.queryParameters,
      'bodyLength': body.length,
      'body': body,
    }),
    headers: {'content-type': 'application/json; charset=utf-8'},
  );
}
