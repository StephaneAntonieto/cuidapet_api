// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cuidapet_api/app/exceptions/request_validation_exception.dart';
import 'package:cuidapet_api/app/helpers/request_mapping.dart';

class UserConfirmInputModel extends RequestMapping {
  int userId;
  String accessToken;
  String? iosDeviceToken;
  String? androidDeviceToken;

  UserConfirmInputModel({
    required this.userId,
    required this.accessToken,
    required String data,
  }) : super(data);

  @override
  void map() {
    iosDeviceToken = data['ios_token'] ?? '';
    androidDeviceToken = data['android_token'] ?? '';
  }

  void validateRequest() {
    final erros = <String, String>{};

    if (iosDeviceToken == null && androidDeviceToken == null) {
      erros['social_type or android_token'] = 'required';
    }

    if (erros.isNotEmpty) {
      throw RequestValidationException(erros);
    }
  }
}
