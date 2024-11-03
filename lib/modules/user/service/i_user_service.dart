import 'package:cuidapet_api/entities/user.dart';

abstract interface class IUserService {
  Future<User> createUser(User user);
}
