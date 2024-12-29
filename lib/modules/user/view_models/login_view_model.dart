import 'package:cuidapet_api/app/exceptions/request_validation_exception.dart';
import 'package:cuidapet_api/app/helpers/request_mapping.dart';

class LoginViewModel extends RequestMapping {
  late String login;
  String? password;
  late bool socialLogin;
  String? avatar;
  String? socialType;
  String? socialKey;
  late bool supplierUser;

  LoginViewModel(super.dataRequest);

  @override
  void map() {
    // login = data['login'] ?? '';
    // password = data.containsKey('password') ? data['password'] : '';
    // socialLogin = data['social_login'] ?? false;
    // avatar = data.containsKey('avatar') ? data['avatar'] : '';
    // socialType = data.containsKey('social_type') ? data['social_type'] : '';
    // socialKey = data.containsKey('social_key') ? data['social_key'] : '';
    // supplierUser = data['supplier_user'] ?? false;
    login = data['login'];
    password = data['password'];
    socialLogin = data['social_login'];
    avatar = data['avatar'];
    socialType = data['social_type'];
    socialKey = data['social_key'];
    supplierUser = data['supplier_user'];
  }

  void loginEmailValidate() {
    final erros = <String, String>{};

    if (password == null) {
      erros['password'] = 'required';
    }

    if (erros.isNotEmpty) {
      throw RequestValidationException(erros);
    }
  }

  void loginSocialValidate() {
    final erros = <String, String>{};

    if (socialType == null) {
      erros['social_type'] = 'required';
    }

    if (socialKey == null) {
      erros['social_key'] = 'required';
    }

    if (erros.isNotEmpty) {
      throw RequestValidationException(erros);
    }
  }
}
