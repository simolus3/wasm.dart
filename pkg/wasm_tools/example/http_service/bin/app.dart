import 'package:wasi/http/service.dart';
import 'package:wasi_http_service/app_handler.dart';

void main() {
  serveWasiShelf((_) => createAppHandler());
}
