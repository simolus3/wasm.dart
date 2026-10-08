import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf_router/shelf_router.dart';

shelf.Handler createAppHandler({http.Client? httpClient}) {
  final router = Router()
    ..get('/', _handleIndex)
    ..get('/hello/<name>', _handleHello)
    ..get('/api/info', _handleInfo)
    ..post('/echo', _handleEcho)
    ..get(
      '/client-demo',
      (shelf.Request req) => _handleClientDemo(req, httpClient),
    );

  return const shelf.Pipeline()
      .addMiddleware(_wasiServerHeaderMiddleware)
      .addHandler(router.call);
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

shelf.Response _handleIndex(shelf.Request request) {
  return shelf.Response.ok(
    _indexHtml,
    headers: {'content-type': 'text/html; charset=utf-8'},
  );
}

shelf.Response _handleHello(shelf.Request request, String name) {
  final decodedName = Uri.decodeComponent(name);
  return shelf.Response.ok(
    const JsonEncoder.withIndent('  ').convert({
      'greeting': 'Hello, $decodedName! 👋',
      'runtime': 'wasmtime (wasi:http/service@0.3.0)',
      'router': 'package:shelf_router',
      'path': request.requestedUri.path,
      'query': request.requestedUri.queryParameters,
    }),
    headers: {'content-type': 'application/json; charset=utf-8'},
  );
}

shelf.Response _handleInfo(shelf.Request request) {
  return shelf.Response.ok(
    const JsonEncoder.withIndent('  ').convert({
      'component': 'wasi:http/service@0.3.0',
      'compiler': 'dart2wasm --standalone',
      'framework': ['package:shelf', 'package:shelf_router', 'package:http'],
      'method': request.method,
      'requestedUri': request.requestedUri.toString(),
      'headers': request.headers,
    }),
    headers: {'content-type': 'application/json; charset=utf-8'},
  );
}

Future<shelf.Response> _handleEcho(shelf.Request request) async {
  final body = await request.readAsString();
  Object? parsedBody = body;
  try {
    if (body.trim().isNotEmpty) {
      parsedBody = json.decode(body);
    }
  } catch (_) {
    // Keep as plain string if not JSON.
  }

  return shelf.Response.ok(
    const JsonEncoder.withIndent('  ').convert({
      'echoedMethod': request.method,
      'echoedPath': request.requestedUri.path,
      'echoedQuery': request.requestedUri.queryParameters,
      'contentType': request.headers['content-type'],
      'bodyLength': body.length,
      'body': parsedBody,
    }),
    headers: {'content-type': 'application/json; charset=utf-8'},
  );
}

Future<shelf.Response> _handleClientDemo(
  shelf.Request request,
  http.Client? httpClient,
) async {
  if (httpClient == null) {
    return shelf.Response(
      501,
      body: json.encode({'error': 'No http.Client configured'}),
      headers: {'content-type': 'application/json; charset=utf-8'},
    );
  }

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

  final methodParam = request.requestedUri.queryParameters['method']
      ?.toUpperCase();
  final usePost =
      methodParam == 'POST' ||
      (methodParam == null && targetUri.path.endsWith('/echo'));

  if (!usePost) {
    final upstream = await httpClient.get(
      targetUri,
      headers: {'user-agent': 'WasiHttpClient/0.3 (dart2wasm)'},
    );
    return shelf.Response.ok(
      const JsonEncoder.withIndent('  ').convert({
        'client': 'WasiHttpClient (package:http over wasi:http/client@0.3.0)',
        'outboundMethod': 'GET',
        'outboundUrl': targetUri.toString(),
        'upstreamStatus': upstream.statusCode,
        'upstreamHeaders': upstream.headers,
        'upstreamBodyPreview': upstream.body.length > 300
            ? '${upstream.body.substring(0, 300)}...'
            : upstream.body,
      }),
      headers: {'content-type': 'application/json; charset=utf-8'},
    );
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

  Object? upstreamJson = upstream.body;
  try {
    upstreamJson = json.decode(upstream.body);
  } catch (_) {}

  return shelf.Response.ok(
    const JsonEncoder.withIndent('  ').convert({
      'client': 'WasiHttpClient (package:http over wasi:http/client@0.3.0)',
      'outboundMethod': 'POST',
      'outboundUrl': targetUri.toString(),
      'upstreamStatus': upstream.statusCode,
      'upstreamHeaders': upstream.headers,
      'upstreamResponse': upstreamJson,
    }),
    headers: {'content-type': 'application/json; charset=utf-8'},
  );
}

const _indexHtml = r'''
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Dart + package:shelf on Wasmtime (wasi:http 0.3)</title>
  <style>
    :root { color-scheme: dark; font-family: system-ui, -apple-system, sans-serif; }
    body { max-width: 780px; margin: 2.5rem auto; padding: 0 1.25rem; background: #0f172a; color: #e2e8f0; }
    h1 { color: #38bdf8; margin-bottom: 0.25rem; }
    .subtitle { color: #94a3b8; margin-top: 0; margin-bottom: 1.5rem; }
    .card { background: #1e293b; border: 1px solid #334155; border-radius: 10px; padding: 1.25rem; margin-bottom: 1rem; }
    .row { display: flex; gap: 0.5rem; flex-wrap: wrap; margin-bottom: 0.75rem; }
    button { background: #0284c7; color: white; border: none; padding: 0.55rem 1rem; border-radius: 6px; cursor: pointer; font-weight: 600; }
    button:hover { background: #0369a1; }
    pre { background: #090d16; border: 1px solid #1e293b; padding: 1rem; border-radius: 8px; overflow-x: auto; color: #a7f3d0; }
    code { color: #7dd3fc; }
  </style>
</head>
<body>
  <h1>🎯 Dart + <code>package:shelf</code> on Wasmtime</h1>
  <p class="subtitle">Compiled with <code>dart2wasm --standalone</code> + <code>package:wasm_tools</code> to a <code>wasi:http/service@0.3.0</code> Component</p>

  <div class="card">
    <h3>Try Routes Live (<code>package:shelf_router</code> + <code>WasiHttpClient</code>)</h3>
    <div class="row">
      <button onclick="callRoute('GET', '/hello/Dash?lang=dart&wasm=true')">GET /hello/Dash</button>
      <button onclick="callRoute('GET', '/api/info')">GET /api/info</button>
      <button onclick="callRoute('POST', '/echo?mode=json', JSON.stringify({hello: 'from browser', componentModel: 0.3}))">POST /echo (JSON)</button>
      <button onclick="callRoute('GET', '/client-demo?url=' + encodeURIComponent(new URL('/echo?via=wasi-http-client', location.href).href))">GET /client-demo (wasi:http/client)</button>
      <button onclick="callRoute('GET', '/does-not-exist')">GET /does-not-exist (404)</button>
    </div>
    <pre id="output">HTTP 200 OK
x-powered-by: dart2wasm + wasi:http/service@0.3.0 + package:shelf
content-type: application/json; charset=utf-8

{
  "greeting": "Hello, Wasm Beyond the Browser! 👋",
  "runtime": "wasmtime 49.0.0 (wasi:http/service@0.3.0)",
  "compiler": "dart2wasm --standalone (WasmGC + try_table)",
  "framework": [
    "package:shelf",
    "package:shelf_router"
  ],
  "path": "/hello/Wasm%20Beyond%20the%20Browser",
  "query": {
    "lang": "dart",
    "component_model": "0.3.0"
  }
}</pre>
  </div>

  <script>
    async function callRoute(method, path, body) {
      const out = document.getElementById('output');
      out.textContent = `Requesting ${method} ${path}...`;
      const res = await fetch(path, {
        method,
        headers: body ? {'content-type': 'application/json'} : {},
        body
      });
      const text = await res.text();
      out.textContent = `HTTP ${res.status} ${res.statusText}\nx-powered-by: ${res.headers.get('x-powered-by')}\ncontent-type: ${res.headers.get('content-type')}\n\n${text}`;
    }
  </script>
</body>
</html>
''';
