import '../../../../../models/message.dart';
import '../../../../../models/post/post.dart';
import '../../../../../models/user_personal_info.dart';
import '../../../domain/entities/sender_info.dart';

abstract class FireStoreUserDb {
  Future<List<bool>> updateChannelId(
      {required List<UserPersonalInfo> callThoseUsers,
      required String myPersonalId,
      required String channelId});

  Future<void> updateChatsOfGroups({required Message messageInfo});

  Future<void> sendNotification(
      {required String userId, required Message message});

  Future<void> createUser(UserPersonalInfo newUserInfo);

  Future<void> cancelJoiningToRoom(String userId);

  Future<void> clearChannelsIds(
      {required List<dynamic> usersIds, required String myPersonalId});

  Future<UserPersonalInfo> getUserInfo(dynamic userId);

  Stream<List<UserPersonalInfo>> getAllUsers();

  Future<List<UserPersonalInfo>> getAllUnFollowersUsers(
      UserPersonalInfo myPersonalInfo);

  Stream<UserPersonalInfo> getMyPersonalInfoInReelTime();

  Future<List<UserPersonalInfo>> getSpecificUsersInfo({
    String fieldName = "",
    required List<dynamic> usersIds,
    String userUid = "",
  });

  Future<SenderInfo> extractUsersForSingleChatInfo(SenderInfo usersInfo);

  Future<List<SenderInfo>> extractUsersChatInfo(
      {required List<SenderInfo> messagesDetails});

  Future<SenderInfo> extractUsersForGroupChatInfo(SenderInfo usersInfo);

  Future<List<SenderInfo>> getMessagesOfChat({required String userId});

  Future<SenderInfo> getChatOfUser({required String chatUid});

  Future updateProfileImage({required String imageUrl, required String userId});

  Future updateUserInfo(UserPersonalInfo userInfo);

  Future<void> updateUserPosts(
      {required String userId, required Post postInfo});

  Future<UserPersonalInfo?> getUserFromUserName({required String userName});

  Future removeUserPost({required String postId});

  Future updateUserStories({required String userId, required String storyId});
  Future followThisUser(String followingUserId, String myPersonalId);

  Future unFollowThisUser(String followingUserId, String myPersonalId);

  Future arrayRemoveOfField({
    required String fieldName,
    required String removeThisId,
    required String userUid,
  });

  Future deleteThisStory({required String storyId});

  Future<List> getSpecificUsersPosts(List<dynamic> usersIds);

  Stream<List<UserPersonalInfo>> searchAboutUser(
      {required String name, required bool searchForSingleLetter});
}
