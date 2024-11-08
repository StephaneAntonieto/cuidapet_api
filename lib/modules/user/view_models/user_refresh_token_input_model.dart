import 'package:cuidapet_api/app/helpers/request_mapping.dart';

class UserRefreshTokenInputModel extends RequestMapping {
  int user;
  int? supplier;
  String accessToken;
  late String refreshToken;

  UserRefreshTokenInputModel({
    required String dataRequest,
    required this.user,
    required this.accessToken,
    this.supplier,
  }) : super(dataRequest);

  @override
  void map() {
    refreshToken = data['refresh_token'] ?? '';
  }
}
