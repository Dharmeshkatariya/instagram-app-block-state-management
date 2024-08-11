import '../../../../../../models/notification.dart';
import '../../../../../../models/user_personal_info.dart';
import '../../../../domain/entities/notification_check.dart';

abstract class FirebaseNotificationDb {
  Future<UserPersonalInfo> createNewDeviceToken(
      {required String userId, required UserPersonalInfo myPersonalInfo});

  Future<void> deleteDeviceToken({required String userId});

  Future<String> createNotification(CustomNotification newNotification);

  Future<List<CustomNotification>> getNotifications({required String userId});

  Future<void> deleteNotification(
      {required NotificationCheck notificationCheck});
}
