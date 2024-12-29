// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cuidapet_api/entities/chat.dart';
import 'package:cuidapet_api/entities/device_token.dart';
import 'package:cuidapet_api/entities/supplier.dart';
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

  @override
  Future<Chat?> findChatById(int chatId) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();
      final query = '''
        SELECT
          c.id,
          c.data_criacao,
          c.status,
          a.nome AS agendamento_nome,
          a.nome_pet AS agendamento_nome_pet,
          a.fornecedor_id,
          a.usuario_id,
          f.nome AS fornec_nome,
          f.logo,
          u.android_token AS user_android_token,
          u.ios_token AS user_ios_token,
          uf.android_token AS fornec_android_token,
          uf.ios_token AS fornec_ios_token
        FROM chats AS c
          INNER JOIN agendamento a ON a.id = c.agendamento_id
          INNER JOIN fornecedor f ON f.id = a.fornecedor_id
          INNER JOIN usuario u ON u.id = a.usuario_id
          INNER JOIN usuario uf ON uf.fornecedor_id = f.id
        WHERE c.id = ?
      ''';

      final result = await conn.query(query, [chatId]);

      if (result.isNotEmpty) {
        final resultMysql = result.first;
        return Chat(
          id: resultMysql['id'],
          status: resultMysql['status'],
          name: resultMysql['agendamento_nome'],
          petName: resultMysql['agendamento_nome_pet'],
          supplier: Supplier(
            id: resultMysql['fornecedor_id'],
            name: resultMysql['fornec_nome'],
          ),
          user: resultMysql['usuario_id'],
          userDeviceToken: DeviceToken(
            android: (resultMysql['user_android_token'] as Blob?)?.toString(),
            ios: (resultMysql['user_ios_token'] as Blob?)?.toString(),
          ),
          supplierDeviceToken: DeviceToken(
            android: (resultMysql['fornec_android_token'] as Blob?)?.toString(),
            ios: (resultMysql['fornec_ios_token'] as Blob?)?.toString(),
          ),
        );
      }
      return null;
    } on MySqlException catch (e, s) {
      log.error('Erro ao buscar dado por chat', e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<List<Chat>> getChatsByUser(int user) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();

      final query = '''
        select
          c.id, c.data_criacao, c.status,
          a.nome, a.nome_pet, a.fornecedor_id, a.usuario_id,
          f.nome as fornec_nome, f.logo
        from chats as c
        inner join agendamento a on a.id = c.agendamento_id
        inner join fornecedor f on f.id = a.fornecedor_id
        where a.usuario_id = ?
        and c.status = 'A'
        order by c.data_criacao
      ''';

      final result = await conn.query(query, [user]);

      return result
          .map(
            (c) => Chat(
              id: c['id'],
              user: c['usuario_id'],
              supplier: Supplier(
                id: c['fornecedor_id'],
                name: c['fornec_nome'],
                logo: (c['logo'] as Blob?)?.toString(),
              ),
              name: c['nome'],
              petName: c['nome_pet'],
              status: c['status'],
            ),
          )
          .toList();
    } on MySqlException catch (e, s) {
      log.error('Erro ao buscar chats de um usuario', e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<List<Chat>> getChatsBySupplier(int supplier) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();

      final query = '''
        select
          c.id, c.data_criacao, c.status,
          a.nome, a.nome_pet, a.fornecedor_id, a.usuario_id,
          f.nome as fornec_nome, f.logo
        from chats as c
        inner join agendamento a on a.id = c.agendamento_id
        inner join fornecedor f on f.id = a.fornecedor_id
        where a.fornecedor_id = ?
        and c.status = 'A'
        order by c.data_criacao
      ''';

      final result = await conn.query(query, [supplier]);

      return result
          .map(
            (c) => Chat(
              id: c['id'],
              user: c['usuario_id'],
              supplier: Supplier(
                id: c['fornecedor_id'],
                name: c['fornec_nome'],
                logo: (c['logo'] as Blob?)?.toString(),
              ),
              name: c['nome'],
              petName: c['nome_pet'],
              status: c['status'],
            ),
          )
          .toList();
    } on MySqlException catch (e, s) {
      log.error('Erro ao buscar chats de um fornecedor', e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }
}
