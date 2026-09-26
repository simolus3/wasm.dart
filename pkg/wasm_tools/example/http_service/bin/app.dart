import 'package:wasi_http_service/app_handler.dart';
import 'package:wasi_http_service/wasi_shelf.dart';

void main() {
  serveWasiShelf(createAppHandler);
}
