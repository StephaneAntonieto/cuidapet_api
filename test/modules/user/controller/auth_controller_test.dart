import 'dart:convert';

import 'package:cuidapet_api/app/exceptions/user_notfound_exception.dart';
import 'package:cuidapet_api/app/logger/i_logger.dart';
import 'package:cuidapet_api/entities/user.dart';
import 'package:cuidapet_api/modules/user/controller/auth_controller.dart';
import 'package:cuidapet_api/modules/user/service/i_user_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../core/fixture/fixture_reader.dart';
import '../../../core/log/mock_logger.dart';
import '../../../core/shelf/mock_shelf_request.dart';
import 'mock/mock_user_service.dart';

void main() {
  late IUserService userService;
  late ILogger log;
  late AuthController authController;
  late Request request;

  setUp(() {
    userService = MockUserService();
    log = MockLogger();
    authController = AuthController(userService: userService, log: log);
    request = MockShelfRequest();
  });

  group('Group test login', () {
    test('Should login with success', () async {
      //Arrange
      final loginRequestFixture = FixtureReader.getJsonData(
          'modules/user/controller/fixture/login_with_email_password_request.json');

      final loginRequestData = jsonDecode(loginRequestFixture);
      final login = loginRequestData['login'];
      final password = loginRequestData['password'];
      final supplierUser = loginRequestData['supplier_user'];

      when(() => request.readAsString())
          .thenAnswer((_) async => loginRequestFixture);

      when(() =>
              userService.loginWithEmailPassword(login, password, supplierUser))
          .thenAnswer((_) async => User(id: 1, email: login));

      //Act
      final response = await authController.login(request);

      //Assert
      final responseData = jsonDecode(await response.readAsString());

      expect(response.statusCode, 200);
      expect(responseData['access_token'], isNotEmpty);
      verify(() =>
              userService.loginWithEmailPassword(login, password, supplierUser))
          .called(1);
      verifyNever(
          () => userService.loginWithSocial(any(), any(), any(), any()));
    });

    test('Should return RequestValidateException on login', () async {
      //Arrange
      final loginRequestFixture = FixtureReader.getJsonData(
          'modules/user/controller/fixture/login_with_email_password_request_validate_error.json');

      when(() => request.readAsString())
          .thenAnswer((_) async => loginRequestFixture);

      //Act
      final response = await authController.login(request);

      //Assert
      final responseData = jsonDecode(await response.readAsString());

      expect(response.statusCode, 400);
      expect(responseData['password'], 'required');
      verifyNever(
          () => userService.loginWithEmailPassword(any(), any(), any()));
      verifyNever(
          () => userService.loginWithSocial(any(), any(), any(), any()));
    });

    test('Should return UserNotFound on login', () async {
      //Arrange
      final loginRequestFixture = FixtureReader.getJsonData(
          'modules/user/controller/fixture/login_with_email_password_request.json');

      final loginRequestData = jsonDecode(loginRequestFixture);
      final login = loginRequestData['login'];
      final password = loginRequestData['password'];
      final supplierUser = loginRequestData['supplier_user'];

      when(() => request.readAsString())
          .thenAnswer((_) async => loginRequestFixture);

      when(() =>
              userService.loginWithEmailPassword(login, password, supplierUser))
          .thenThrow(UserNotfoundException(message: 'Usuario nao encontrado'));

      //Act
      final response = await authController.login(request);

      //Assert
      expect(response.statusCode, 403);
      verify(() =>
          userService.loginWithEmailPassword(login, password, supplierUser));
      verifyNever(
          () => userService.loginWithSocial(any(), any(), any(), any()));
    });
  });

  group('Group test login social', () {
    test('Should login with social success', () async {
      //Arrange
      final requestFixture = FixtureReader.getJsonData(
          'modules/user/controller/fixture/login_with_social_request.json');
      final requestData = jsonDecode(requestFixture);
      final email = requestData['login'];
      final avatar = requestData['avatar'];
      final socialType = requestData['social_type'];
      final socialKey = requestData['social_key'];

      when(() => request.readAsString())
          .thenAnswer((_) async => requestFixture);
      when(() =>
              userService.loginWithSocial(email, avatar, socialType, socialKey))
          .thenAnswer((_) async => User(
                id: 1,
                email: email,
                imageAvatar: avatar,
                registerType: socialType,
                socialKey: socialKey,
              ));
      //Act
      final response = await authController.login(request);

      //Assert
      final responseData = jsonDecode(await response.readAsString());
      expect(response.statusCode, 200);
      expect(responseData['access_token'], isNotEmpty);
      verify(() =>
              userService.loginWithSocial(email, avatar, socialType, socialKey))
          .called(1);
      verifyNever(
          () => userService.loginWithEmailPassword(any(), any(), any()));
    });

    test('Should return RquestValidationException', () async {
      //Arrange
      final requestFixture = FixtureReader.getJsonData(
          'modules/user/controller/fixture/login_with_social_request_validation_error.json');

      when(() => request.readAsString())
          .thenAnswer((_) async => requestFixture);

      //Act
      final response = await authController.login(request);

      //Assert
      final responseData = jsonDecode(await response.readAsString());
      expect(response.statusCode, 400);
      expect(responseData['social_type'], 'required');
      expect(responseData['social_key'], 'required');

      verifyNever(
          () => userService.loginWithSocial(any(), any(), any(), any()));
      verifyNever(
          () => userService.loginWithEmailPassword(any(), any(), any()));
    });
  });
}
