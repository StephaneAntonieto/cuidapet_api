// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cuidapet_api/app/exceptions/service_exception.dart';
import 'package:cuidapet_api/app/exceptions/user_notfound_exception.dart';
import 'package:cuidapet_api/app/helpers/jwt_helper.dart';
import 'package:cuidapet_api/app/logger/i_logger.dart';
import 'package:cuidapet_api/entities/user.dart';
import 'package:cuidapet_api/modules/user/data/i_user_repository.dart';
import 'package:cuidapet_api/modules/user/view_models/refresh_token_view_model.dart';
import 'package:cuidapet_api/modules/user/view_models/user_confirm_input_model.dart';
import 'package:cuidapet_api/modules/user/view_models/user_refresh_token_input_model.dart';
import 'package:cuidapet_api/modules/user/view_models/user_save_input_model.dart';
import 'package:injectable/injectable.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

import './i_user_service.dart';

@LazySingleton(as: IUserService)
class UserService implements IUserService {
  IUserRepository userRepository;
  ILogger log;

  UserService({
    required this.userRepository,
    required this.log,
  });

  @override
  Future<User> createUser(UserSaveInputModel user) {
    final userEntity = User(
      email: user.email,
      password: user.password,
      registerType: 'APP',
      supplierId: user.supplierId,
    );

    return userRepository.createUser(userEntity);
  }

  @override
  Future<User> loginWithEmailPassword(
          String email, String password, bool supplierUser) =>
      userRepository.loginWithEmailPassword(email, password, supplierUser);

  @override
  Future<User> loginWithSocial(
    String email,
    String avatar,
    String socialType,
    String socialKey,
  ) async {
    try {
      return await userRepository.loginByEmailSocialKey(
        email,
        socialKey,
        socialType,
      );
    } on UserNotfoundException catch (e) {
      log.error('Usuário não encontrado, criando um usuário', e);

      final user = User(
        email: email,
        imageAvatar: avatar,
        registerType: socialType,
        socialKey: socialKey,
        password: DateTime.now().toString(),
      );

      return await userRepository.createUser(user);
    }
  }

  @override
  Future<String> confirmLogin(UserConfirmInputModel inputModel) async {
    final refreshToken = JwtHelper.refreshToken(inputModel.accessToken);

    final user = User(
      id: inputModel.userId,
      refreshToken: refreshToken,
      iosToken: inputModel.iosDeviceToken,
      androidToken: inputModel.androidDeviceToken,
    );

    await userRepository.updateUserDeviceTokenAndRefreshToken(user);

    return refreshToken;
  }

  @override
  Future<RefreshTokenViewModel> refreshToken(
      UserRefreshTokenInputModel model) async {
    _validateRefreshToken(model);

    final newAccessToken = JwtHelper.generateJwt(model.user, model.supplier);
    final newRefreshToken = JwtHelper.refreshToken(newAccessToken);
    final user = User(
      id: model.user,
      refreshToken: newRefreshToken,
    );

    await userRepository.updateRefreshToken(user);

    return RefreshTokenViewModel(
      accessToken: newAccessToken,
      refreshToken: newRefreshToken,
    );
  }

  void _validateRefreshToken(UserRefreshTokenInputModel model) {
    try {
      final refreshToken = model.refreshToken.split(' ');

      if (refreshToken.length != 2 || refreshToken.first != 'Bearer') {
        log.error('Refresh token invalido');
        throw ServiceException('Refresh token invalido');
      }

      final refreshTokenClaim = JwtHelper.getClaims(refreshToken.last);

      refreshTokenClaim.validate(issuer: model.accessToken);
    } on ServiceException {
      rethrow;
    } on JwtException catch (e, s) {
      log.error('Refresh token invalido', e, s);
      throw ServiceException('Refresh token invalido');
    } catch (e) {
      throw ServiceException('Error ao validar refresh token');
    }
  }

  @override
  Future<User> findById(int id) => userRepository.findById(id);
}
