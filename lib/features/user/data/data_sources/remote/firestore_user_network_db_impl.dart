import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:instagram_dharmesh_bloc_demo/features/notification/data/data_sources/remote/device_notification_db/device_notification_impl.dart';

import 'package:instagram_dharmesh_bloc_demo/models/message.dart';

import '../../../../../core/constants/constants.dart';
import '../../../../../core/utils/strings_manager.dart';
import '../../../../../models/post/post.dart';
import '../../../../../models/push_notification.dart';
import '../../../../../models/user_personal_info.dart';
import '../../../domain/entities/sender_info.dart';
import 'firestore_user_db.dart';

class FireStoreUserNetworkDbImpl implements FireStoreUserDb {
  static final _fireStoreUserCollection =
      FirebaseFirestore.instance.collection('users');
  DeviceNotificationImpl deviceNotificationImpl = DeviceNotificationImpl();

  @override
  Future arrayRemoveOfField(
      {required String fieldName,
      required String removeThisId,
      required String userUid}) async {
    await _fireStoreUserCollection.doc(userUid).update({
      fieldName: FieldValue.arrayRemove([removeThisId])
    });
  }

  @override
  Future<void> cancelJoiningToRoom(String userId) async {
    await _fireStoreUserCollection.doc(userId).update({"channelId": ""});
  }

  @override
  Future<void> clearChannelsIds(
      {required List usersIds, required String myPersonalId}) async {
    await _fireStoreUserCollection.doc(myPersonalId).update({"channelId": ""});
    for (final userId in usersIds) {
      await _fireStoreUserCollection.doc(userId).update({"channelId": ""});
    }
  }

  @override
  Future<void> createUser(UserPersonalInfo newUserInfo) async {
    await _fireStoreUserCollection
        .doc(newUserInfo.userId)
        .set(newUserInfo.toMap());
  }

  @override
  Future deleteThisStory({required String storyId}) async {
    await _fireStoreUserCollection.doc(myPersonalId).update({
      'stories': FieldValue.arrayRemove([storyId])
    });
  }

  @override
  Future<List<SenderInfo>> extractUsersChatInfo(
      {required List<SenderInfo> messagesDetails}) async {
    for (int i = 0; i < messagesDetails.length; i++) {
      if (messagesDetails[i].lastMessage!.isThatGroup) {
        messagesDetails[i] =
            await extractUsersForGroupChatInfo(messagesDetails[i]);
      } else {
        messagesDetails[i] =
            await extractUsersForSingleChatInfo(messagesDetails[i]);
      }
    }
    return messagesDetails;
  }

  @override
  Future<SenderInfo> extractUsersForGroupChatInfo(SenderInfo usersInfo) async {
    if (usersInfo.lastMessage != null) {
      for (final receiverId in usersInfo.lastMessage!.receiversIds) {
        UserPersonalInfo userInfo = await getUserInfo(receiverId);
        if (usersInfo.receiversInfo == null) {
          usersInfo.receiversInfo = [userInfo];
          usersInfo.receiversIds = [userInfo.userId];
        } else {
          usersInfo.receiversInfo!.add(userInfo);
          usersInfo.receiversIds!.add(userInfo.userId);
        }
      }
      String userId = usersInfo.lastMessage!.senderId;
      UserPersonalInfo userInfo = await getUserInfo(userId);
      usersInfo.receiversInfo!.add(userInfo);
      usersInfo.receiversIds!.add(userInfo.userId);
    }

    return usersInfo;
  }

  @override
  Future<SenderInfo> extractUsersForSingleChatInfo(SenderInfo usersInfo) async {
    if (usersInfo.lastMessage != null) {
      String userId;
      if (usersInfo.lastMessage?.senderId != myPersonalId) {
        userId = usersInfo.lastMessage!.senderId;
      } else {
        userId = usersInfo.lastMessage!.receiversIds[0];
      }
      UserPersonalInfo userInfo = await getUserInfo(userId);
      usersInfo.receiversInfo = [userInfo];
      usersInfo.receiversIds = [userInfo.userId];
    }

    return usersInfo;
  }

  @override
  Future followThisUser(String followingUserId, String myPersonalId) async {
    await _fireStoreUserCollection.doc(followingUserId).update({
      'followers': FieldValue.arrayUnion([myPersonalId])
    });

    await _fireStoreUserCollection.doc(myPersonalId).update({
      'following': FieldValue.arrayUnion([followingUserId])
    });
  }

  @override
  Future<List<UserPersonalInfo>> getAllUnFollowersUsers(
      UserPersonalInfo myPersonalInfo) async {
    QuerySnapshot<Map<String, dynamic>> snap =
        await _fireStoreUserCollection.get();
    List<UserPersonalInfo> usersInfo = [];
    for (final doc in snap.docs) {
      UserPersonalInfo formatUser = UserPersonalInfo.fromDocSnap(doc.data());
      bool isThatMe = formatUser.userId == myPersonalInfo.userId;
      bool isThatUserFollowedByMe =
          !myPersonalInfo.followedPeople.contains(formatUser.userId);
      if (!isThatMe && isThatUserFollowedByMe) {
        usersInfo.add(formatUser);
      }
    }
    return usersInfo;
  }

  @override
  Stream<List<UserPersonalInfo>> getAllUsers() {
    Stream<QuerySnapshot<Map<String, dynamic>>> snapshots =
        _fireStoreUserCollection.snapshots();
    return snapshots.map((snapshot) {
      List<UserPersonalInfo> usersInfo = [];
      for (final doc in snapshot.docs) {
        UserPersonalInfo userInfo = UserPersonalInfo.fromDocSnap(doc.data());
        if (userInfo.userId != myPersonalId) usersInfo.add(userInfo);
      }
      return usersInfo;
    });
  }

  @override
  Future<SenderInfo> getChatOfUser({required String chatUid}) async {
    DocumentReference<Map<String, dynamic>> userCollection =
        _fireStoreUserCollection.doc(myPersonalId);
    userCollection.update({'numberOfNewMessages': 0});
    DocumentSnapshot<Map<String, dynamic>> doc =
        await userCollection.collection("chats").doc(chatUid).get();
    Message messageInfo = Message.fromJson(doc: doc);
    return SenderInfo(lastMessage: messageInfo);
  }

  @override
  Future<List<SenderInfo>> getMessagesOfChat({required String userId}) async {
    List<SenderInfo> allUsers = [];

    DocumentReference<Map<String, dynamic>> userCollection =
        _fireStoreUserCollection.doc(userId);
    userCollection.update({'numberOfNewMessages': 0});
    QuerySnapshot<Map<String, dynamic>> snap =
        await userCollection.collection("chats").get();

    for (final chatInfo in snap.docs) {
      QueryDocumentSnapshot<Map<String, dynamic>> query = chatInfo;
      Message messageInfo = Message.fromJson(query: query);
      allUsers.add(SenderInfo(lastMessage: messageInfo));
    }
    return allUsers;
  }

  @override
  Stream<UserPersonalInfo> getMyPersonalInfoInReelTime() {
    if (myPersonalId.isNotEmpty) {
      Stream<DocumentSnapshot<Map<String, dynamic>>> snapshotsInfo =
          _fireStoreUserCollection.doc(myPersonalId).snapshots();
      return snapshotsInfo.map((snapshot) {
        UserPersonalInfo info = UserPersonalInfo.fromDocSnap(snapshot.data());
        return info;
      });
    } else {
      return Stream.error("No personal id");
    }
  }

  @override
  Future<List<UserPersonalInfo>> getSpecificUsersInfo(
      {String fieldName = "",
      required List usersIds,
      String userUid = ""}) async {
    List<UserPersonalInfo> usersInfo = [];
    List<dynamic> ids = [];
    for (final userid in usersIds) {
      if (!ids.contains(userid)) {
        DocumentSnapshot<Map<String, dynamic>> snap =
            await _fireStoreUserCollection.doc(userid).get();
        if (snap.exists) {
          UserPersonalInfo postReformat =
              UserPersonalInfo.fromDocSnap(snap.data());
          usersInfo.add(postReformat);
        } else {
          if (fieldName.isNotEmpty && userUid.isNotEmpty) {
            await arrayRemoveOfField(
                removeThisId: userid, userUid: userUid, fieldName: fieldName);
          }
        }
        ids.add(userid);
      }
    }
    return usersInfo;
  }

  @override
  Future<List> getSpecificUsersPosts(List usersIds) async {
    List postsInfo = [];
    List<dynamic> usersIdsUnique = [];
    for (int i = 0; i < usersIds.length; i++) {
      if (!usersIdsUnique.contains(usersIds[i])) {
        DocumentSnapshot<Map<String, dynamic>> snap =
            await _fireStoreUserCollection.doc(usersIds[i]).get();
        if (snap.exists) {
          postsInfo += snap.get('posts');
        }
        usersIdsUnique.add(usersIds[i]);
      }
    }
    return postsInfo;
  }

  @override
  Future<UserPersonalInfo?> getUserFromUserName(
      {required String userName}) async {
    UserPersonalInfo? userPersonalInfo;
    await _fireStoreUserCollection
        .where('userName', isEqualTo: userName)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot<Map<String, dynamic>> snap = snapshot.docs[0];
        userPersonalInfo = UserPersonalInfo.fromDocSnap(snap.data());
      }
    });
    return userPersonalInfo;
  }

  @override
  Future<UserPersonalInfo> getUserInfo(userId) async {
    DocumentSnapshot<Map<String, dynamic>> snap =
        await _fireStoreUserCollection.doc(userId).get();
    if (snap.exists) {
      return UserPersonalInfo.fromDocSnap(snap.data());
    } else {
      return Future.error(StringsManager.userNotExist.tr);
    }
  }

  @override
  Future removeUserPost({required String postId}) async {
    QuerySnapshot<Map<String, dynamic>> document =
        await _fireStoreUserCollection
            .where("posts", arrayContains: postId)
            .get();
    for (var element in document.docs) {
      _fireStoreUserCollection.doc(element.id).update({
        'posts': FieldValue.arrayRemove([postId])
      });
    }
  }

  @override
  Stream<List<UserPersonalInfo>> searchAboutUser(
      {required String name, required bool searchForSingleLetter}) {
    name = name.toLowerCase();
    Stream<QuerySnapshot<Map<String, dynamic>>> snapSearch;
    if (searchForSingleLetter) {
      snapSearch = _fireStoreUserCollection
          .where("userName", isEqualTo: name)
          .snapshots();
    } else {
      snapSearch = _fireStoreUserCollection
          .where("charactersOfName", arrayContains: name)
          .snapshots();
    }
    return snapSearch.map((snapshot) => snapshot.docs.map((doc) {
          UserPersonalInfo userInfo = UserPersonalInfo.fromDocSnap(doc.data());
          return userInfo;
        }).toList());
  }

  @override
  Future<void> sendNotification(
      {required String userId, required Message message}) async {
    DocumentReference<Map<String, dynamic>> userCollection =
        _fireStoreUserCollection.doc(userId);
    if (userId != myPersonalId) {
      userCollection.update({"numberOfNewMessages": FieldValue.increment(1)});
      UserPersonalInfo receiverInfo = await getUserInfo(userId);
      String token = receiverInfo.deviceToken;
      if (token.isNotEmpty) {
        String body = message.message.isNotEmpty
            ? message.message
            : (message.isThatImage
                ? "Send image"
                : (message.isThatPost
                    ? "Share with you a post"
                    : "Send message"));
        PushNotification detail = PushNotification(
          title: message.senderInfo?.name ?? "A user",
          body: body,
          deviceToken: token,
          isThatGroupChat: message.isThatGroup,
          notificationRoute: "message",
          routeParameterId:
              message.isThatGroup ? message.chatOfGroupId : message.senderId,
        );
        await deviceNotificationImpl.sendPopupNotification(
            pushNotification: detail);
      }
    }
  }

  @override
  Future unFollowThisUser(String followingUserId, String myPersonalId) async {
    await _fireStoreUserCollection.doc(followingUserId).update({
      'followers': FieldValue.arrayRemove([myPersonalId])
    });

    await _fireStoreUserCollection.doc(myPersonalId).update({
      'following': FieldValue.arrayRemove([followingUserId])
    });
  }

  @override
  Future<List<bool>> updateChannelId(
      {required List<UserPersonalInfo> callThoseUsers,
      required String myPersonalId,
      required String channelId}) async {
    await _fireStoreUserCollection
        .doc(myPersonalId)
        .update({"channelId": channelId});
    List<bool> isUsersAvailable = [];
    for (final user in callThoseUsers) {
      DocumentSnapshot<Map<String, dynamic>> collection =
          await _fireStoreUserCollection.doc(user.userId).get();
      UserPersonalInfo userInfo =
          UserPersonalInfo.fromDocSnap(collection.data());
      if (userInfo.channelId.isEmpty) {
        isUsersAvailable.add(true);
        await _fireStoreUserCollection
            .doc(user.userId)
            .update({"channelId": channelId});
      } else {
        isUsersAvailable.add(false);
      }
    }
    return isUsersAvailable;
  }

  @override
  Future<void> updateChatsOfGroups({required Message messageInfo}) async {
    for (final userId in messageInfo.receiversIds) {
      await _fireStoreUserCollection.doc(userId).update({
        "chatsOfGroups": FieldValue.arrayUnion([messageInfo.chatOfGroupId])
      });

      await sendNotification(userId: userId, message: messageInfo);
    }
    await _fireStoreUserCollection.doc(messageInfo.senderId).update({
      "chatsOfGroups": FieldValue.arrayUnion([messageInfo.chatOfGroupId])
    });
  }

  @override
  Future updateProfileImage(
      {required String imageUrl, required String userId}) async {
    await _fireStoreUserCollection.doc(userId).update({
      "profileImageUrl": imageUrl,
    });
  }

  @override
  Future updateUserInfo(UserPersonalInfo userInfo) async {
    await _fireStoreUserCollection
        .doc(userInfo.userId)
        .update(userInfo.toMap());
  }

  @override
  Future<void> updateUserPosts(
      {required String userId, required Post postInfo}) async {
    DocumentReference<Map<String, dynamic>> collection =
        _fireStoreUserCollection.doc(userId);
    await collection.update({
      'posts': FieldValue.arrayUnion([postInfo.postUid]),
    });
    return await _updateThreeLastPostUrl(userId, postInfo);
  }

  static Future<void> _updateThreeLastPostUrl(
      String userId, Post postInfo) async {
    DocumentReference<Map<String, dynamic>> collection =
        _fireStoreUserCollection.doc(userId);
    Map<String, dynamic>? snap = (await collection.get()).data();
    List<dynamic> lastPosts = snap?["lastThreePostUrls"] ??= [];
    if (lastPosts.length >= 3) lastPosts = lastPosts.sublist(0, 3);
    bool isThatImage = postInfo.isThatImage;

    if (isThatImage) {
      lastPosts.add(postInfo.postUrl);
    } else {
      if (postInfo.coverOfVideoUrl.isEmpty) return;
      lastPosts.add(postInfo.coverOfVideoUrl);
    }
    return await collection
        .update({'lastThreePostUrls': FieldValue.arrayUnion(lastPosts)});
  }

  @override
  Future updateUserStories(
      {required String userId, required String storyId}) async {
    await _fireStoreUserCollection.doc(userId).update({
      'stories': FieldValue.arrayUnion([storyId])
    });
  }
}
