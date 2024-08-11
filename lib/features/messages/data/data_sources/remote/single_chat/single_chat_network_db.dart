import '../../../../../../models/message.dart';

abstract class SingleChatNetworkDb {
  Future<Message> sendMessage({
    required String userId,
    required String chatId,
    required Message message,
  });

  Future<void> updateLastMessage({
    required String userId,
    required String chatId,
    required Message? message,
    required bool isThatOnlyMessageInChat,
  });

  Future<void> deleteMessage(
      {required String userId,
      required String chatId,
      required String messageId});
  Stream<List<Message>> getMessages({required String receiverId});
}
