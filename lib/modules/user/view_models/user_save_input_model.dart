import 'package:cuidapet_api/app/helpers/request_mapping.dart';

class UserSaveInputModel extends RequestMapping {
  late String email;
  late String password;
  int? supplierId;

  UserSaveInputModel({
    required this.email,
    required this.password,
    this.supplierId,
  }) : super.empty();

  UserSaveInputModel.requestMapping(super.dataRequest);

  @override
  void map() {
    email = data['email'];
    password = data['password'];
  }
}
