import 'package:cuidapet_api/entities/user.dart';

abstract interface class IUserRepository {
  Future<User> createUser(User user);
}
