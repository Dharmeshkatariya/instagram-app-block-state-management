import 'dart:io';
import 'dart:typed_data';
import 'package:instagram_dharmesh_bloc_demo/features/messages/data/data_sources/remote/group_chat/group_chat_network_db_impl.dart';
import 'package:instagram_dharmesh_bloc_demo/features/notification/data/data_sources/remote/firebase_notification/firebase_notification_db_impl.dart';
import 'package:instagram_dharmesh_bloc_demo/models/message.dart';
import 'package:instagram_dharmesh_bloc_demo/models/post/post.dart';
import 'package:instagram_dharmesh_bloc_demo/models/user_personal_info.dart';
import '../../../../core/constants/constants.dart';
import '../../../auth/data/data_sources/remote/firebase_storage.dart';
import '../../../messages/data/data_sources/remote/single_chat/single_chat_network_db_impl.dart';
import '../../domain/entities/sender_info.dart';
import '../../domain/entities/specific_user.dart';
import '../../domain/repository/user_repository.dart';
import '../data_sources/remote/firestore_user_db.dart';
import '../data_sources/remote/firestore_user_network_db_impl.dart';

class UserRepositoryImpl implements FireStoreUserRepository {
  final FireStoreUserDb userNetworkDb;
  UserRepositoryImpl({required this.userNetworkDb});

  final notificationNetworkDb = FirebaseNotificationDbImpl();
  final fireSingleChatNetworkDb = SingleChatNetworkDbImpl();
  final firebaseGroupChatNetworkDb = GroupChatNetworkDbImpl();

  @override
  Future<void> addNewUser(UserPersonalInfo newUserInfo) async {
    try {
      await userNetworkDb.createUser(newUserInfo);
      await notificationNetworkDb.createNewDeviceToken(
          userId: newUserInfo.userId, myPersonalInfo: newUserInfo);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<UserPersonalInfo> getPersonalInfo(
      {required String userId, bool getDeviceToken = false}) async {
    try {
      UserPersonalInfo myPersonalInfo = await userNetworkDb.getUserInfo(userId);
      if (isThatMobile && getDeviceToken) {
        UserPersonalInfo updateInfo =
            await notificationNetworkDb.createNewDeviceToken(
                userId: userId, myPersonalInfo: myPersonalInfo);
        myPersonalInfo = updateInfo;
      }
      return myPersonalInfo;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<UserPersonalInfo> updateUserInfo(
      {required UserPersonalInfo userInfo}) async {
    try {
      await userNetworkDb.updateUserInfo(userInfo);
      return getPersonalInfo(userId: userInfo.userId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<UserPersonalInfo> updateUserPostsInfo(
      {required String userId, required Post postInfo}) async {
    try {
      await userNetworkDb.updateUserPosts(userId: userId, postInfo: postInfo);
      return await getPersonalInfo(userId: userId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<String> uploadProfileImage(
      {required Uint8List photo,
      required String userId,
      required String previousImageUrl}) async {
    try {
      String imageUrl = await FirebaseStoragePost.uploadData(
          data: photo, folderName: 'personalImage');
      await userNetworkDb.updateProfileImage(
          imageUrl: imageUrl, userId: userId);
      await FirebaseStoragePost.deleteImageFromStorage(previousImageUrl);
      return imageUrl;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<FollowersAndFollowingsInfo> getFollowersAndFollowingsInfo(
      {required List<dynamic> followersIds,
      required List<dynamic> followingsIds}) async {
    try {
      List<UserPersonalInfo> followersInfo =
          await userNetworkDb.getSpecificUsersInfo(
              usersIds: followersIds,
              fieldName: "followers",
              userUid: myPersonalId);
      List<UserPersonalInfo> followingsInfo =
          await userNetworkDb.getSpecificUsersInfo(
              usersIds: followingsIds,
              fieldName: "following",
              userUid: myPersonalId);
      return FollowersAndFollowingsInfo(
          followersInfo: followersInfo, followingsInfo: followingsInfo);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> followThisUser(
      String followingUserId, String myPersonalId) async {
    try {
      return await userNetworkDb.followThisUser(followingUserId, myPersonalId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> unFollowThisUser(
      String followingUserId, String myPersonalId) async {
    try {
      return await userNetworkDb.unFollowThisUser(
          followingUserId, myPersonalId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  /// [fieldName] , [userUid] in case one of this users not exist, it will be deleted from the list in fireStore

  @override
  Future<List<UserPersonalInfo>> getSpecificUsersInfo({
    required List<dynamic> usersIds,
  }) async {
    try {
      return await userNetworkDb.getSpecificUsersInfo(usersIds: usersIds);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<List<UserPersonalInfo>> getAllUnFollowersUsers(
      UserPersonalInfo myPersonalInfo) {
    try {
      return userNetworkDb.getAllUnFollowersUsers(myPersonalInfo);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Stream<UserPersonalInfo> getMyPersonalInfo() =>
      userNetworkDb.getMyPersonalInfoInReelTime();

  @override
  Stream<List<UserPersonalInfo>> getAllUsers() => userNetworkDb.getAllUsers();

  @override
  Future<UserPersonalInfo?> getUserFromUserName(
      {required String userName}) async {
    try {
      return await userNetworkDb.getUserFromUserName(userName: userName);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Stream<List<UserPersonalInfo>> searchAboutUser(
          {required String name, required bool searchForSingleLetter}) =>
      userNetworkDb.searchAboutUser(
          name: name, searchForSingleLetter: searchForSingleLetter);

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
      Message myMessageInfo = await fireSingleChatNetworkDb.sendMessage(
          userId: messageInfo.senderId,
          chatId: messageInfo.receiversIds[0],
          message: messageInfo);

      await fireSingleChatNetworkDb.sendMessage(
          userId: messageInfo.receiversIds[0],
          chatId: messageInfo.senderId,
          message: messageInfo);

      await userNetworkDb.sendNotification(
          userId: messageInfo.receiversIds[0], message: messageInfo);

      return myMessageInfo;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Stream<List<Message>> getMessages({required String receiverId}) =>
      fireSingleChatNetworkDb.getMessages(receiverId: receiverId);

  @override
  Future<void> deleteMessage(
      {required Message messageInfo,
      Message? replacedMessage,
      required bool isThatOnlyMessageInChat}) async {
    try {
      String senderId = messageInfo.senderId;
      String receiverId = messageInfo.receiversIds[0];
      for (int i = 0; i < 2; i++) {
        String userId = i == 0 ? senderId : receiverId;
        String chatId = i == 0 ? receiverId : senderId;
        await fireSingleChatNetworkDb.deleteMessage(
            userId: userId, chatId: chatId, messageId: messageInfo.messageUid);
        if (replacedMessage != null || isThatOnlyMessageInChat) {
          await fireSingleChatNetworkDb.updateLastMessage(
              userId: userId,
              chatId: chatId,
              isThatOnlyMessageInChat: isThatOnlyMessageInChat,
              message: replacedMessage);
        }
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<SenderInfo> getSpecificChatInfo(
      {required String chatUid, required bool isThatGroup}) async {
    try {
      if (isThatGroup) {
        SenderInfo coverChatInfo =
            await firebaseGroupChatNetworkDb.getChatInfo(chatId: chatUid);
        SenderInfo messageDetails =
            await userNetworkDb.extractUsersForGroupChatInfo(coverChatInfo);
        return messageDetails;
      } else {
        SenderInfo coverChatInfo =
            await userNetworkDb.getChatOfUser(chatUid: chatUid);
        SenderInfo messageDetails =
            await userNetworkDb.extractUsersForSingleChatInfo(coverChatInfo);
        return messageDetails;
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<List<SenderInfo>> getChatUserInfo(
      {required UserPersonalInfo myPersonalInfo}) async {
    try {
      List<SenderInfo> allChatsOfGroupsInfo = await firebaseGroupChatNetworkDb
          .getSpecificChatsInfo(chatsIds: myPersonalInfo.chatsOfGroups);
      List<SenderInfo> allChatsInfo =
          await userNetworkDb.getMessagesOfChat(userId: myPersonalInfo.userId);
      List<SenderInfo> allChats = allChatsInfo + allChatsOfGroupsInfo;
      List<SenderInfo> allUsersInfo =
          await userNetworkDb.extractUsersChatInfo(messagesDetails: allChats);
      return allUsersInfo;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
