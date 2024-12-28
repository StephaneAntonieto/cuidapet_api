import 'package:cuidapet_api/entities/chat.dart';

abstract interface class IChatRepository {
  Future<int> startChat(int scheduleId);

  Future<Chat?> findChatById(int chatId);
}
