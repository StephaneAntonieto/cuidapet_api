// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../modules/categories/controller/categories_controller.dart' as _i55;
import '../../modules/categories/data/categories_repository.dart' as _i537;
import '../../modules/categories/data/i_categories_repository.dart' as _i870;
import '../../modules/categories/service/categories_service.dart' as _i805;
import '../../modules/categories/service/i_categories_service.dart' as _i803;
import '../../modules/chat/controller/chat_controller.dart' as _i194;
import '../../modules/chat/data/chat_repository.dart' as _i199;
import '../../modules/chat/data/i_chat_repository.dart' as _i216;
import '../../modules/chat/service/chat_service.dart' as _i51;
import '../../modules/chat/service/i_chat_service.dart' as _i189;
import '../../modules/schedules/controller/schedule_controller.dart' as _i436;
import '../../modules/schedules/data/i_schedule_repository.dart' as _i411;
import '../../modules/schedules/data/schedule_repository.dart' as _i451;
import '../../modules/schedules/service/i_schedule_service.dart' as _i701;
import '../../modules/schedules/service/schedule_service.dart' as _i541;
import '../../modules/supplier/controller/supplier_controller.dart' as _i331;
import '../../modules/supplier/data/i_supplier_repository.dart' as _i417;
import '../../modules/supplier/data/supplier_repository.dart' as _i151;
import '../../modules/supplier/service/i_supplier_service.dart' as _i448;
import '../../modules/supplier/service/supplier_service.dart' as _i977;
import '../../modules/user/controller/auth_controller.dart' as _i477;
import '../../modules/user/controller/user_controller.dart' as _i983;
import '../../modules/user/data/i_user_repository.dart' as _i872;
import '../../modules/user/data/user_repository.dart' as _i755;
import '../../modules/user/service/i_user_service.dart' as _i610;
import '../../modules/user/service/user_service.dart' as _i457;
import '../database/database_connection.dart' as _i396;
import '../database/i_database_connection.dart' as _i77;
import '../facades/push_notification_facade.dart' as _i982;
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
    gh.lazySingleton<_i982.PushNotificationFacade>(
        () => _i982.PushNotificationFacade(log: gh<_i742.ILogger>()));
    gh.lazySingleton<_i417.ISupplierRepository>(() => _i151.SupplierRepository(
          connection: gh<_i77.IDatabaseConnection>(),
          log: gh<_i742.ILogger>(),
        ));
    gh.lazySingleton<_i411.IScheduleRepository>(() => _i451.ScheduleRepository(
          connection: gh<_i77.IDatabaseConnection>(),
          log: gh<_i742.ILogger>(),
        ));
    gh.lazySingleton<_i870.ICategoriesRepository>(
        () => _i537.CategoriesRepository(
              connection: gh<_i77.IDatabaseConnection>(),
              log: gh<_i742.ILogger>(),
            ));
    gh.lazySingleton<_i701.IScheduleService>(() =>
        _i541.ScheduleService(repository: gh<_i411.IScheduleRepository>()));
    gh.lazySingleton<_i872.IUserRepository>(() => _i755.UserRepository(
          connection: gh<_i77.IDatabaseConnection>(),
          log: gh<_i742.ILogger>(),
        ));
    gh.lazySingleton<_i216.IChatRepository>(() => _i199.ChatRepository(
          connection: gh<_i77.IDatabaseConnection>(),
          log: gh<_i742.ILogger>(),
        ));
    gh.lazySingleton<_i610.IUserService>(() => _i457.UserService(
          userRepository: gh<_i872.IUserRepository>(),
          log: gh<_i742.ILogger>(),
        ));
    gh.factory<_i477.AuthController>(() => _i477.AuthController(
          userService: gh<_i610.IUserService>(),
          log: gh<_i742.ILogger>(),
        ));
    gh.factory<_i983.UserController>(() => _i983.UserController(
          userService: gh<_i610.IUserService>(),
          log: gh<_i742.ILogger>(),
        ));
    gh.lazySingleton<_i803.ICategoriesService>(() =>
        _i805.CategoriesService(repository: gh<_i870.ICategoriesRepository>()));
    gh.factory<_i55.CategoriesController>(() => _i55.CategoriesController(
          service: gh<_i803.ICategoriesService>(),
          log: gh<_i742.ILogger>(),
        ));
    gh.lazySingleton<_i448.ISupplierService>(() => _i977.SupplierService(
          repository: gh<_i417.ISupplierRepository>(),
          userService: gh<_i610.IUserService>(),
        ));
    gh.factory<_i436.ScheduleController>(() => _i436.ScheduleController(
          service: gh<_i701.IScheduleService>(),
          log: gh<_i742.ILogger>(),
        ));
    gh.lazySingleton<_i189.IChatService>(() => _i51.ChatService(
          repository: gh<_i216.IChatRepository>(),
          pushNotificationFacade: gh<_i982.PushNotificationFacade>(),
        ));
    gh.factory<_i194.ChatController>(() => _i194.ChatController(
          service: gh<_i189.IChatService>(),
          log: gh<_i742.ILogger>(),
        ));
    gh.factory<_i331.SupplierController>(() => _i331.SupplierController(
          service: gh<_i448.ISupplierService>(),
          log: gh<_i742.ILogger>(),
        ));
    return this;
  }
}
