// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cuidapet_api/app/helpers/request_mapping.dart';
import 'package:cuidapet_api/modules/user/view_models/platform.dart';

class UserUpdateTokenDeviceInputModel extends RequestMapping {
  int userId;
  late String token;
  late Platform platform;

  UserUpdateTokenDeviceInputModel({
    required this.userId,
    required String dataRequest,
  }) : super(dataRequest);

  @override
  void map() {
    token = data['token'];
    platform = (data['platform'].toLowerCase() == 'ios'
        ? Platform.ios
        : Platform.android);
    // if (data['platform'].toLowerCase() == 'ios') {
    //   platform = Platform.ios;
    // }
    // if (data['platform'].toLowerCase() == 'android') {
    //   platform = Platform.android;
    // }
  }

  @override
  bool operator ==(covariant UserUpdateTokenDeviceInputModel other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.token == token &&
        other.platform == platform;
  }

  @override
  int get hashCode => userId.hashCode ^ token.hashCode ^ platform.hashCode;
}
