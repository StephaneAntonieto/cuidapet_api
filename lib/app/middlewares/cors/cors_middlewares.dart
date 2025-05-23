import 'dart:io';
import 'package:shelf/shelf.dart';

import 'package:cuidapet_api/app/middlewares/middlewares.dart';

class CorsMiddlewares extends Middlewares {
  final Map<String, String> headers = {
    'Acces-Control-Allow-Origin': '*',
    'Acces-Control-Allow-Methods': 'GET, POST, PATCH, PUT, DELETE, OPTIONS',
    'Acces-Control-Allow-Header':
        '${HttpHeaders.contentTypeHeader}, ${HttpHeaders.authorizationHeader}',
  };

  @override
  Future<Response> execute(Request request) async {
    if (request.method == 'OPTIONS') {
      return Response(HttpStatus.ok, headers: headers);
    }

    final response = await innerHandler(request);

    return response.change(headers: headers);
  }
}
