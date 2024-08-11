import '../../../../../../models/notification.dart';
import '../../../../../../models/push_notification.dart';

abstract class DeviceNotificationDb {
  Future<void> pushNotification(
      {required CustomNotification customNotification, required String token});

  Future<void> sendPopupNotification(
      {required PushNotification pushNotification});
}
