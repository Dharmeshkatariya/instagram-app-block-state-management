import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:instagram_dharmesh_bloc_demo/features/notification/domain/entities/notification_check.dart';
import 'package:instagram_dharmesh_bloc_demo/injection_container.dart';
import 'package:instagram_dharmesh_bloc_demo/models/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../../models/user_personal_info.dart';
import '../../../../../user/data/data_sources/remote/firestore_user_network_db_impl.dart';
import '../device_notification_db/device_notification_impl.dart';
import 'firebase_notification_db.dart';

class FirebaseNotificationDbImpl implements FirebaseNotificationDb {
  static final _fireStoreUserCollection =
      FirebaseFirestore.instance.collection('users');
  DeviceNotificationImpl deviceNotificationImpl = DeviceNotificationImpl();
  FireStoreUserNetworkDbImpl fireStoreUserNetworkDbImpl =
      FireStoreUserNetworkDbImpl();

  @override
  Future<UserPersonalInfo> createNewDeviceToken(
      {required String userId,
      required UserPersonalInfo myPersonalInfo}) async {
    final SharedPreferences sharePrefs = locator<SharedPreferences>();

    String? token = await FirebaseMessaging.instance.getToken();

    if (token != null && !(myPersonalInfo.deviceToken == token)) {
      await _fireStoreUserCollection.doc(userId).update({'deviceToken': token});
      myPersonalInfo.deviceToken = token;
      await sharePrefs.setString("deviceToken", token);
    }
    return myPersonalInfo;
  }

  @override
  Future<String> createNotification(CustomNotification newNotification) async {
    DocumentReference<Map<String, dynamic>> userCollection =
        _fireStoreUserCollection.doc(newNotification.receiverId);
    userCollection
        .update({"numberOfNewNotifications": FieldValue.increment(1)});
    UserPersonalInfo receiverInfo = await fireStoreUserNetworkDbImpl
        .getUserInfo(newNotification.receiverId);
    String token = receiverInfo.deviceToken;
    if (token.isNotEmpty) {
      await deviceNotificationImpl.pushNotification(
          customNotification: newNotification, token: token);
    }
    return await _createNotification(newNotification);
  }

  static Future<String> _createNotification(
      CustomNotification newNotification) async {
    DocumentReference<Map<String, dynamic>> userCollection =
        _fireStoreUserCollection.doc(newNotification.receiverId);

    CollectionReference<Map<String, dynamic>> collection =
        userCollection.collection("notifications");
    DocumentReference<Map<String, dynamic>> addingCollection =
        await collection.add(newNotification.toMap());

    newNotification.notificationUid = addingCollection.id;
    await addingCollection
        .update({"notificationUid": newNotification.notificationUid});

    return newNotification.notificationUid;
  }

  @override
  Future<void> deleteDeviceToken({required String userId}) async {
    await _fireStoreUserCollection.doc(userId).update({'deviceToken': ""});
  }

  @override
  Future<void> deleteNotification(
      {required NotificationCheck notificationCheck}) async {
    CollectionReference<Map<String, dynamic>> collection =
        _fireStoreUserCollection
            .doc(notificationCheck.receiverId)
            .collection("notifications");
    QuerySnapshot<Map<String, dynamic>> getDoc;
    if (notificationCheck.isThatPost) {
      getDoc = await collection
          .where("isThatLike", isEqualTo: notificationCheck.isThatLike)
          .where("isThatPost", isEqualTo: notificationCheck.isThatPost)
          .where("senderId", isEqualTo: notificationCheck.senderId)
          .where("postId", isEqualTo: notificationCheck.postId)
          .get();
    } else {
      getDoc = await collection
          .where("senderId", isEqualTo: notificationCheck.senderId)
          .where("postId", isEqualTo: notificationCheck.postId)
          .get();
    }
    for (final doc in getDoc.docs) {
      collection.doc(doc.id).delete();
    }
  }

  @override
  Future<List<CustomNotification>> getNotifications(
      {required String userId}) async {
    DocumentReference<Map<String, dynamic>> userCollection =
        _fireStoreUserCollection.doc(userId);
    userCollection.update({"numberOfNewNotifications": 0});
    QuerySnapshot<Map<String, dynamic>> snap =
        await userCollection.collection("notifications").get();
    List<CustomNotification> notifications = [];
    for (final doc in snap.docs) {
      final notification = CustomNotification.fromJson(doc.data());
      notifications.add(notification);
    }
    return notifications;
  }
}
