import 'dart:io';

import 'dart:typed_data';

import 'package:instagram_dharmesh_bloc_demo/features/user/data/data_sources/remote/firestore_user_network_db_impl.dart';

import '../../../../models/message.dart';
import '../../../auth/data/data_sources/remote/firebase_storage.dart';
import '../../domain/repository/group_message.dart';
import '../data_sources/remote/group_chat/group_chat_network_db.dart';
import '../data_sources/remote/group_chat/group_chat_network_db_impl.dart';

class FirebaseGroupMessageRepoImpl implements FireStoreGroupMessageRepository {
  final GroupChatNetworkDb firestoreGroupChat;
  FirebaseGroupMessageRepoImpl({required this.firestoreGroupChat});
  final firestoreUser = FireStoreUserNetworkDbImpl();

  @override
  Future<Message> createChatForGroups(Message messageInfo) async {
    try {
      Message messageDetails =
          await firestoreGroupChat.createChatForGroups(messageInfo);
      await firestoreUser.updateChatsOfGroups(messageInfo: messageDetails);
      return messageDetails;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<Message> sendMessage(
      {required Message messageInfo,
      Uint8List? pathOfPhoto,
      required File? recordFile}) async {
    try {
      if (pathOfPhoto != null) {
        String imageUrl = await FirebaseStoragePost.uploadData(
            data: pathOfPhoto, folderName: "messagesFiles");
        messageInfo.imageUrl = imageUrl;
      }
      if (recordFile != null) {
        String recordedUrl = await FirebaseStoragePost.uploadFile(
            folderName: "messagesFiles", postFile: recordFile);
        messageInfo.recordedUrl = recordedUrl;
      }
      bool updateLastMessage = true;
      if (messageInfo.chatOfGroupId.isEmpty) {
        Message newMessageInfo = await createChatForGroups(messageInfo);
        messageInfo = newMessageInfo;
        updateLastMessage = false;
      }
      Message myMessageInfo = await firestoreGroupChat.sendMessage(
          updateLastMessage: updateLastMessage, message: messageInfo);

      for (final userId in messageInfo.receiversIds) {
        await firestoreUser.sendNotification(
            userId: userId, message: messageInfo);
      }

      return myMessageInfo;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Stream<List<Message>> getMessages({required String groupChatUid}) =>
      firestoreGroupChat.getMessages(groupChatUid: groupChatUid);

  @override
  Future<void> deleteMessage({
    required Message messageInfo,
    required String chatOfGroupUid,
    Message? replacedMessage,
  }) async {
    try {
      await firestoreGroupChat.deleteMessage(
          chatOfGroupUid: chatOfGroupUid, messageId: messageInfo.messageUid);
      if (replacedMessage != null) {
        await firestoreGroupChat.updateLastMessage(
            chatOfGroupUid: chatOfGroupUid, message: replacedMessage);
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
