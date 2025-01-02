import 'package:cuidapet_api/app/exceptions/user_notfound_exception.dart';
import 'package:cuidapet_api/app/logger/i_logger.dart';
import 'package:cuidapet_api/entities/user.dart';
import 'package:cuidapet_api/modules/user/data/i_user_repository.dart';
import 'package:cuidapet_api/modules/user/service/i_user_service.dart';
import 'package:cuidapet_api/modules/user/service/user_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../core/log/mock_logger.dart';

class MockUserRepository extends Mock implements IUserRepository {}

void main() {
  late IUserRepository userRepository;
  late ILogger log;
  late IUserService userService;

  setUp(() {
    userRepository = MockUserRepository();
    log = MockLogger();
    userService = UserService(userRepository: userRepository, log: log);
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
}
