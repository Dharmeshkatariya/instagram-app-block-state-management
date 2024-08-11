
import 'package:instagram_dharmesh_bloc_demo/features/notification/data/data_sources/remote/device_notification_db/device_notification_db.dart';
import 'package:instagram_dharmesh_bloc_demo/models/notification.dart';
import 'package:http/http.dart' as http;

import '../../../../../../export.dart';
import '../../../../../../models/push_notification.dart';

class DeviceNotificationImpl implements DeviceNotificationDb {
  @override
  Future<void> pushNotification(
      {required CustomNotification customNotification,
      required String token}) async {
    String notificationRoute;
    String routeParameterId;
    if (customNotification.isThatPost) {
      notificationRoute = "post";
      routeParameterId = customNotification.postId;
    } else {
      notificationRoute = "profile";
      routeParameterId = customNotification.senderId;
    }
    PushNotification detail = PushNotification(
      title: customNotification.senderName,
      body: customNotification.text,
      deviceToken: token,
      notificationRoute: notificationRoute,
      routeParameterId: routeParameterId,

      /// to avoid errors
      isThatGroupChat: false,
      userCallingId: "",
    );
    return await sendPopupNotification(pushNotification: detail);
  }

  @override
  Future<void> sendPopupNotification(
      {required PushNotification pushNotification}) async {
    try {
      try {
        await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',

            /// conect with cloud messaging and get server key from project settings here
            /// replace the points with your key  "key=...." and set it in [notificationKey]
            'Authorization': notificationKey,
          },
          body: jsonEncode(pushNotification.toMap()),
        );
      } catch (e, s) {
        if (kDebugMode) print(s);
      }
    } catch (e) {
      return Future.error("Error with push notification");
    }
  }
}
