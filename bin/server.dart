import 'dart:convert';
import 'dart:io';
import 'package:cuidapet_api/app/middlewares/cors/cors_middlewares.dart';
import 'package:cuidapet_api/app/middlewares/defaultContentType/default_content_type.dart';
import 'package:cuidapet_api/app/middlewares/security/security_middleware.dart';
import 'package:get_it/get_it.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import 'package:cuidapet_api/app/config/application_config.dart';

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  final router = Router();

  router.get(
    '/health',
    (Request request) => Response.ok(jsonEncode({'up': 'true'})),
  );

  final appConfig = ApplicationConfig();
  appConfig.loadConfigApplication(router);

  final getIt = GetIt.I;

  // Configure a pipeline that logs requests.
  final handler = Pipeline()
      .addMiddleware(CorsMiddlewares().handler)
      .addMiddleware(
          DefaultContentType('application/json;charset=utf-8').handler)
      .addMiddleware(SecurityMiddleware(getIt.get()).handler)
      .addMiddleware(logRequests())
      .addHandler(router.call);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
