import 'dart:convert';

import 'package:shelf/shelf.dart' as shelf;
import 'package:test/test.dart';
import 'package:wasi_http_service/app_handler.dart';

void main() {
  late shelf.Handler handler;

  setUp(() {
    handler = createAppHandler();
  });

  test('GET / serves HTML dashboard with x-powered-by header', () async {
    final response = await handler(
      shelf.Request('GET', Uri.parse('http://localhost/')),
    );
    expect(response.statusCode, 200);
    expect(response.headers['content-type'], contains('text/html'));
    expect(
      response.headers['x-powered-by'],
      'dart2wasm + wasi:http/service@0.3.0 + package:shelf',
    );
    expect(await response.readAsString(), contains('package:shelf'));
  });

  test('GET /hello/<name> decodes route parameter and query string', () async {
    final response = await handler(
      shelf.Request(
        'GET',
        Uri.parse('http://localhost/hello/Dash%20Wasm?lang=dart'),
      ),
    );
    expect(response.statusCode, 200);
    final body =
        json.decode(await response.readAsString()) as Map<String, Object?>;
    expect(body['greeting'], 'Hello, Dash Wasm! 👋');
    expect(body['path'], '/hello/Dash%20Wasm');
    expect(body['query'], {'lang': 'dart'});
  });

  test('GET /api/info returns request metadata', () async {
    final response = await handler(
      shelf.Request(
        'GET',
        Uri.parse('http://localhost/api/info'),
        headers: {'x-test': '1'},
      ),
    );
    expect(response.statusCode, 200);
    final body =
        json.decode(await response.readAsString()) as Map<String, Object?>;
    expect(body['component'], 'wasi:http/service@0.3.0');
    expect(body['method'], 'GET');
  });

  test('POST /echo parses JSON and plain text bodies', () async {
    final jsonResp = await handler(
      shelf.Request(
        'POST',
        Uri.parse('http://localhost/echo?mode=json'),
        headers: {'content-type': 'application/json'},
        body: json.encode({'hello': 'wasm', 'count': 3}),
      ),
    );
    expect(jsonResp.statusCode, 200);
    final jsonBody =
        json.decode(await jsonResp.readAsString()) as Map<String, Object?>;
    expect(jsonBody['echoedMethod'], 'POST');
    expect(jsonBody['echoedQuery'], {'mode': 'json'});
    expect(jsonBody['body'], {'hello': 'wasm', 'count': 3});

    final textResp = await handler(
      shelf.Request(
        'POST',
        Uri.parse('http://localhost/echo'),
        headers: {'content-type': 'text/plain'},
        body: 'plain text payload',
      ),
    );
    expect(textResp.statusCode, 200);
    final textBody =
        json.decode(await textResp.readAsString()) as Map<String, Object?>;
    expect(textBody['body'], 'plain text payload');
  });

  test('unknown route returns 404', () async {
    final response = await handler(
      shelf.Request('GET', Uri.parse('http://localhost/does-not-exist')),
    );
    expect(response.statusCode, 404);
  });
}
