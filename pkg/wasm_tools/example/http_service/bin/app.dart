import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart' as shelf;
import 'package:wasi/http/service.dart';

var _requestId = 0;

void main() {
  serveWasiShelf((imports) {
    final client = WasiHttpClient(imports);
    return const shelf.Pipeline()
        .addMiddleware(_wasiServerHeaderMiddleware)
        .addHandler((request) => _router(request, client));
  });
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

FutureOr<shelf.Response> _router(shelf.Request request, http.Client client) =>
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
      ('GET', ['client-demo']) => _handleClientDemo(request, client),
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

Future<shelf.Response> _handleClientDemo(
  shelf.Request request,
  http.Client httpClient,
) async {
  final targetParam = request.requestedUri.queryParameters['url'];
  final Uri targetUri;
  if (targetParam != null && targetParam.isNotEmpty) {
    targetUri = Uri.parse(targetParam);
  } else if (request.requestedUri.hasPort) {
    targetUri = request.requestedUri.replace(
      path: '/echo',
      queryParameters: {'via': 'wasi-http-client'},
    );
  } else {
    targetUri = Uri.parse('http://127.0.0.1:8080/echo?via=wasi-http-client');
  }

  final upstream = await httpClient.post(
    targetUri,
    headers: {
      'content-type': 'application/json',
      'x-wasi-client': 'package:http',
    },
    body: json.encode({
      'message': 'Outbound HTTP request via WasiHttpClient!',
      'interface': 'wasi:http/client@0.3.0',
    }),
  );

  return shelf.Response.ok(
    const JsonEncoder.withIndent('  ').convert({
      'client': 'WasiHttpClient (package:http over wasi:http/client@0.3.0)',
      'outboundUrl': targetUri.toString(),
      'upstreamStatus': upstream.statusCode,
      'upstreamBody': upstream.body,
    }),
    headers: {'content-type': 'application/json; charset=utf-8'},
  );
}
