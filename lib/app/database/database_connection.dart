import 'package:injectable/injectable.dart';
import 'package:mysql1/mysql1.dart';

import 'package:cuidapet_api/app/database/i_database_connection.dart';
import 'package:cuidapet_api/app/config/database_connection_configuration.dart';

@LazySingleton(as: IDatabaseConnection)
class DatabaseConnection implements IDatabaseConnection {
  final DatabaseConnectionConfiguration _configuration;

  DatabaseConnection(this._configuration);

  @override
  Future<MySqlConnection> openConnection() {
    return MySqlConnection.connect(
      ConnectionSettings(
        host: _configuration.host,
        port: _configuration.port,
        user: _configuration.user,
        password: _configuration.password,
        db: _configuration.databaseName,
      ),
    );
  }
}
