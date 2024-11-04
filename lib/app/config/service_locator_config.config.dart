// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../modules/user/controller/auth_controller.dart' as _i477;
import '../../modules/user/data/i_user_repository.dart' as _i872;
import '../../modules/user/data/user_repository.dart' as _i755;
import '../../modules/user/service/i_user_service.dart' as _i610;
import '../../modules/user/service/user_service.dart' as _i457;
import '../database/database_connection.dart' as _i396;
import '../database/i_database_connection.dart' as _i77;
import '../logger/i_logger.dart' as _i742;
import 'database_connection_configuration.dart' as _i32;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.lazySingleton<_i77.IDatabaseConnection>(() =>
        _i396.DatabaseConnection(gh<_i32.DatabaseConnectionConfiguration>()));
    gh.lazySingleton<_i872.IUserRepository>(() => _i755.UserRepository(
          connection: gh<_i77.IDatabaseConnection>(),
          log: gh<_i742.ILogger>(),
        ));
    gh.lazySingleton<_i610.IUserService>(
        () => _i457.UserService(userRepository: gh<_i872.IUserRepository>()));
    gh.factory<_i477.AuthController>(() => _i477.AuthController(
          userService: gh<_i610.IUserService>(),
          log: gh<_i742.ILogger>(),
        ));
    return this;
  }
}
