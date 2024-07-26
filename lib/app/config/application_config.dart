import "package:cuidapet_api/app/config/service_locator_config.dart";
import "package:cuidapet_api/app/routers/router_configure.dart";
import "package:dotenv/dotenv.dart";
import "package:get_it/get_it.dart";

import "package:cuidapet_api/app/config/database_connection_configuration.dart";
import "package:cuidapet_api/app/logger/i_logger.dart";
import "package:cuidapet_api/app/logger/logger_impl.dart";
import "package:shelf_router/shelf_router.dart";

class ApplicationConfig {
  void loadConfigApplication(Router router) {
    _loadDatabaseConfig();
    _configLogger();
    _loadDependencies();
    _loadRoutersConfigure(router);
  }

  void _loadDatabaseConfig() {
    var env = DotEnv(includePlatformEnvironment: true)..load();

    final databaseConfig = DatabaseConnectionConfiguration(
      host: env['DATABASE_HOST'] ?? env['databaseHost']!,
      user: env['DATABASE_USER'] ?? env['databaseUser']!,
      port: int.tryParse(env['DATABASE_PORT'] ?? env['databasePort']!) ?? 0,
      password: env['DATABASE_PASSWORD'] ?? env['databasePassword']!,
      databaseName: env['DATABASE_NAME'] ?? env['databaseName']!,
    );
    GetIt.I.registerSingleton(databaseConfig);
  }

  void _configLogger() =>
      GetIt.I.registerLazySingleton<ILogger>(() => LoggerImpl());

  void _loadDependencies() => configureDependencies();

  void _loadRoutersConfigure(Router router) =>
      RouterConfigure(router).configure();
}
