import '../../../../models/notification.dart';
import '../../domain/entities/notification_check.dart';
import '../../domain/repository/firestore_notification.dart';
import '../data_sources/remote/firebase_notification/firebase_notification_db.dart';

class FireStoreNotificationRepoImpl implements FireStoreNotificationRepository {
  final FirebaseNotificationDb firestoreNotification;
  FireStoreNotificationRepoImpl({required this.firestoreNotification});

  @override
  Future<String> createNotification(
      {required CustomNotification newNotification}) async {
    try {
      return await firestoreNotification.createNotification(newNotification);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<List<CustomNotification>> getNotifications({required String userId}) {
    try {
      return firestoreNotification.getNotifications(userId: userId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> deleteNotification(
      {required NotificationCheck notificationCheck}) {
    try {
      return firestoreNotification.deleteNotification(
          notificationCheck: notificationCheck);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
