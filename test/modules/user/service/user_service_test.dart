import 'package:cuidapet_api/app/exceptions/service_exception.dart';
import 'package:cuidapet_api/app/exceptions/user_notfound_exception.dart';
import 'package:cuidapet_api/app/helpers/jwt_helper.dart';
import 'package:cuidapet_api/app/logger/i_logger.dart';
import 'package:cuidapet_api/entities/user.dart';
import 'package:cuidapet_api/modules/user/data/i_user_repository.dart';
import 'package:cuidapet_api/modules/user/service/i_user_service.dart';
import 'package:cuidapet_api/modules/user/service/user_service.dart';
import 'package:cuidapet_api/modules/user/view_models/user_refresh_token_input_model.dart';
import 'package:dotenv/dotenv.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../core/log/mock_logger.dart';

class MockUserRepository extends Mock implements IUserRepository {}

var env = DotEnv(includePlatformEnvironment: true)..load();
void main() {
  late IUserRepository userRepository;
  late ILogger log;
  late IUserService userService;

  setUp(() {
    userRepository = MockUserRepository();
    log = MockLogger();
    userService = UserService(userRepository: userRepository, log: log);
    registerFallbackValue(User());
  });

  group('Group test Login with email and password', () {
    test('Should login with email n password', () async {
      //Arrange
      final id = 1;
      final email = 'stephane@email.com';
      final password = '123123';
      final supplierUser = false;
      final userMock = User(id: id, email: email);
      when(() => userRepository.loginWithEmailPassword(
          email, password, supplierUser)).thenAnswer((_) async => userMock);

      //Act
      final user = await userService.loginWithEmailPassword(
          email, password, supplierUser);

      //Assert
      expect(user, userMock);
      verify(() =>
              userService.loginWithEmailPassword(email, password, supplierUser))
          .called(1);
    });

    test('Should login with email n password and return UserNotFoundException',
        () async {
      //Arrange
      final email = 'stephane@email.com';
      final password = '123123';
      final supplierUser = false;

      when(() => userRepository.loginWithEmailPassword(
              email, password, supplierUser))
          .thenThrow(UserNotfoundException(message: 'Usuario nao encontrado'));

      //Act
      final call = userService.loginWithEmailPassword;

      //Assert
      expect(() => call(email, password, supplierUser),
          throwsA(isA<UserNotfoundException>()));
      verify(() =>
              userService.loginWithEmailPassword(email, password, supplierUser))
          .called(1);
    });
  });

  group('Group test login with social', () {
    test('Should login with social success', () async {
      //Arrange
      final email = 'stephane@email.com';
      final socialKey = '123';
      final socialType = 'facebook';
      final userReturnLogin = User(
        id: 1,
        email: email,
        socialKey: socialKey,
        registerType: socialType,
      );

      when(() => userRepository.loginByEmailSocialKey(
              email, socialKey, socialType))
          .thenAnswer((_) async => userReturnLogin);

      //Act
      final user =
          await userService.loginWithSocial(email, '', socialType, socialKey);

      //Assert
      expect(user, userReturnLogin);
      verify(
        () =>
            userRepository.loginByEmailSocialKey(email, socialKey, socialType),
      ).called(1);
    });

    test('Should login with social user not found and create a new user',
        () async {
      //Arrange
      final email = 'stephane@email.com';
      final socialKey = '123';
      final socialType = 'facebook';
      final userCreated = User(
        id: 1,
        email: email,
        socialKey: socialKey,
        registerType: socialType,
      );

      when(() => userRepository.loginByEmailSocialKey(
              email, socialKey, socialType))
          .thenThrow(UserNotfoundException(message: 'Usuario nao encontrado'));

      when(() => userRepository.createUser(any<User>()))
          .thenAnswer((_) async => userCreated);

      //Act
      final user =
          await userService.loginWithSocial(email, '', socialType, socialKey);

      //Assert
      expect(user, userCreated);
      verify(() => userRepository.loginByEmailSocialKey(
          email, socialKey, socialType)).called(1);
      verify(() => userRepository.createUser(any<User>())).called(1);
    });
  });

  group('Group test refresh token', () {
    // test('Should refresh token with success', () async {
    //   //Arrange
    //   //É preciso mudar o env para 0 na hora do teste
    //   env.addAll({'refresh_token_not_before_hours': '0'});
    //   final userId = 1;
    //   final accessToken = JwtHelper.generateJwt(userId, null);
    //   final refreshToken = JwtHelper.refreshToken(accessToken);
    //   final model = UserRefreshTokenInputModel(
    //     dataRequest: '{"refresh_token":"$refreshToken"}',
    //     user: userId,
    //     accessToken: accessToken,
    //   );
    //   when(() => userRepository.updateRefreshToken(any()))
    //       .thenAnswer((m) async => m);

    //   //Act
    //   final responseToken = await userService.refreshToken(model);

    //   //Assert
    //   expect(responseToken, isA<RefreshTokenViewModel>());
    //   expect(responseToken.accessToken, isNotEmpty);
    //   expect(responseToken.refreshToken, isNotEmpty);
    //   verify(() => userRepository.updateRefreshToken(any())).called(1);
    // });

    test('Should return validate error (Bearer)', () async {
      //Arrange
      final model = UserRefreshTokenInputModel(
        dataRequest: '{"refresh_token":""}',
        user: 1,
        accessToken: 'accessToken',
      );

      //Act
      final call = userService.refreshToken;

      //Assert
      expect(() => call(model), throwsA(isA<ServiceException>()));
    });

    test('Should return validate error (JwtException)', () async {
      //Arrange
      final userId = 1;
      final accessToken = JwtHelper.generateJwt(userId, null);
      final refreshToken = JwtHelper.refreshToken('123');
      final model = UserRefreshTokenInputModel(
        dataRequest: '{"refresh_token":"$refreshToken"}',
        user: userId,
        accessToken: accessToken,
      );
      //Act
      final call = userService.refreshToken;

      //Assert
      expect(() => call(model), throwsA(isA<ServiceException>()));
    });
  });
}
