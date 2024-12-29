import 'dart:convert';
import 'package:cuidapet_api/app/logger/i_logger.dart';
import 'package:dotenv/dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

var env = DotEnv(includePlatformEnvironment: true)..load();

@LazySingleton()
class PushNotificationFacade {
  ILogger log;

  PushNotificationFacade({
    required this.log,
  });

  Future<void> sendMessage({
    required List<String?> devices,
    required String title,
    required String body,
    required Map<String, dynamic> payload,
  }) async {
    try {
      final request = {
        'notification': {
          'body': body,
          'title': title,
        },
        'priority': 'high',
        'data': {
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done',
          'payload': payload,
        },
      };

      final firebaseKey = env['FIREBASE_PUSH_KEY'] ?? env['firebasePushKey'];

      if (firebaseKey == null) {
        log.error('Chave do firebase não configurada');
        return;
      }

      for (var device in devices) {
        if (device != null) {
          request['to'] = device;
          log.info('Enviando notificação para o dispositivo: $device');

          final result = await http.post(
            Uri.parse('https://fcm.googleapis.com/fcm/send'),
            body: jsonEncode(request),
            headers: {
              'Authorization': 'key=$firebaseKey',
              'Content-Type': 'application/json',
            },
          );

          // Aqui vai acontecer um erro devido a não implementação do firebase no momento
          final responseData = jsonDecode(result.body);

          if (responseData['failure'] == 1) {
            log.error(
                'Erro ao enviar notificação para o dispositivo: $device error: ${responseData['results']?[0]['error']}');
          } else {
            log.info(
                'Notificação enviada com sucesso para o dispositivo: $device');
          }
        }
      }
    } catch (e, s) {
      log.error('Erro ao enviar notificação', e, s);
    }
  }
}
