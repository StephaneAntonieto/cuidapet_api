// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:injectable/injectable.dart';
import 'package:mysql1/mysql1.dart';

import 'package:cuidapet_api/app/database/i_database_connection.dart';
import 'package:cuidapet_api/app/exceptions/database_exception.dart';
import 'package:cuidapet_api/app/logger/i_logger.dart';

import './i_chat_repository.dart';

@LazySingleton(as: IChatRepository)
class ChatRepository implements IChatRepository {
  final IDatabaseConnection connection;
  final ILogger log;

  ChatRepository({
    required this.connection,
    required this.log,
  });

  @override
  Future<int> startChat(int scheduleId) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();
      final result = await conn.query('''
      insert into chats(agendamento_id, status, data_criacao) values(?, ?, ?)
      ''', [
        scheduleId,
        'A',
        DateTime.now().toIso8601String(),
      ]);

      return result.insertId!;
    } on MySqlException catch (e, s) {
      log.error('Erro ao iniciar chat', e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }
}
