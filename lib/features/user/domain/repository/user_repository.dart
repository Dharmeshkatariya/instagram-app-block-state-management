import 'dart:io';
import 'dart:typed_data';

import '../../../../models/message.dart';
import '../../../../models/post/post.dart';
import '../../../../models/user_personal_info.dart';
import '../entities/sender_info.dart';
import '../entities/specific_user.dart';

abstract class FireStoreUserRepository {
  Future<void> addNewUser(UserPersonalInfo newUserInfo);

  Future<UserPersonalInfo> getPersonalInfo(
      {required String userId, bool getDeviceToken = false});

  Future<List<UserPersonalInfo>> getAllUnFollowersUsers(
      UserPersonalInfo myPersonalInfo);

  Stream<List<UserPersonalInfo>> getAllUsers();

  Future<UserPersonalInfo?> getUserFromUserName({required String userName});

  Future<UserPersonalInfo> updateUserPostsInfo(
      {required String userId, required Post postInfo});

  Future<UserPersonalInfo> updateUserInfo({required UserPersonalInfo userInfo});

  Future<String> uploadProfileImage(
      {required Uint8List photo,
      required String userId,
      required String previousImageUrl});

  Future<FollowersAndFollowingsInfo> getFollowersAndFollowingsInfo(
      {required List<dynamic> followersIds,
      required List<dynamic> followingsIds});

  Future<List<UserPersonalInfo>> getSpecificUsersInfo(
      {required List<dynamic> usersIds});

  Future<void> followThisUser(String followingUserId, String myPersonalId);

  Future<void> unFollowThisUser(String followingUserId, String myPersonalId);
  Stream<UserPersonalInfo> getMyPersonalInfo();

  Stream<List<UserPersonalInfo>> searchAboutUser(
      {required String name, required bool searchForSingleLetter});

  Future<Message> sendMessage(
      {required Message messageInfo,
      Uint8List? pathOfPhoto,
      required File? recordFile});

  Stream<List<Message>> getMessages({required String receiverId});

  Future<void> deleteMessage(
      {required Message messageInfo,
      Message? replacedMessage,
      required bool isThatOnlyMessageInChat});
  Future<SenderInfo> getSpecificChatInfo(
      {required String chatUid, required bool isThatGroup});
  Future<List<SenderInfo>> getChatUserInfo(
      {required UserPersonalInfo myPersonalInfo});
}
