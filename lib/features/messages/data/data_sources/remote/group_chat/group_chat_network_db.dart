import '../../../../../../models/message.dart';
import '../../../../../user/domain/entities/sender_info.dart';

abstract class GroupChatNetworkDb {
  Future<Message> createChatForGroups(Message messageInfo);

  Future<Message> sendMessage(
      {bool updateLastMessage = true, required Message message});

  Future<void> updateLastMessage({
    required String chatOfGroupUid,
    required Message message,
  });

  Future<List<SenderInfo>> getSpecificChatsInfo(
      {required List<dynamic> chatsIds});

  Future<SenderInfo> getChatInfo({required dynamic chatId});

  Stream<List<Message>> getMessages({required String groupChatUid});

  Future<void> deleteMessage(
      {required String chatOfGroupUid, required String messageId});
}
