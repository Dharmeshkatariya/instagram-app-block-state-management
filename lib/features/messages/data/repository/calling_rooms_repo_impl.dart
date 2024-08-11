import 'package:instagram_dharmesh_bloc_demo/features/notification/data/data_sources/remote/device_notification_db/device_notification_impl.dart';
import 'package:instagram_dharmesh_bloc_demo/features/user/data/data_sources/remote/firestore_user_network_db_impl.dart';

import '../../../../core/constants/constants.dart';
import '../../../../models/push_notification.dart';
import '../../../../models/user_personal_info.dart';
import '../../domain/entities/calling_status.dart';
import '../../domain/repository/calling_rooms_repository.dart';
import '../data_sources/remote/calling_room/calling_room_network_db.dart';
import '../data_sources/remote/calling_room/calling_room_network_db_impl.dart';

class CallingRoomsRepoImpl implements CallingRoomsRepository {
  final CallingRoomNetworkDb fireStoreCallingRoom;
  CallingRoomsRepoImpl({required this.fireStoreCallingRoom});

  final firestoreUser = FireStoreUserNetworkDbImpl();
  final DeviceNotification = DeviceNotificationImpl();
  @override
  Future<String> createCallingRoom(
      {required UserPersonalInfo myPersonalInfo,
      required List<UserPersonalInfo> callThoseUsersInfo}) async {
    try {
      String channelId = await fireStoreCallingRoom.createCallingRoom(
          myPersonalInfo: myPersonalInfo,
          initialNumberOfUsers: callThoseUsersInfo.length + 1);

      List<bool> isUsersAvailable = await firestoreUser.updateChannelId(
          callThoseUsers: callThoseUsersInfo,
          channelId: channelId,
          myPersonalId: myPersonalInfo.userId);
      bool isAnyOneAvailable = false;
      for (int i = 0; i < isUsersAvailable.length; i++) {
        if (isUsersAvailable[i]) {
          isAnyOneAvailable = true;
          UserPersonalInfo receiverInfo =
              await firestoreUser.getUserInfo(callThoseUsersInfo[i].userId);
          String token = receiverInfo.deviceToken;
          if (token.isNotEmpty) {
            String body = "Calling you";
            PushNotification detail = PushNotification(
              title: myPersonalInfo.name,
              body: body,
              deviceToken: token,
              notificationRoute: "call",
              userCallingId: myPersonalInfo.userId,
              routeParameterId: channelId,
              isThatGroupChat: callThoseUsersInfo.length > 1,
            );
            await DeviceNotification.sendPopupNotification(
                pushNotification: detail);
          }
        }
      }
      if (isAnyOneAvailable) {
        return channelId;
      } else {
        throw Exception("Busy");
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Stream<bool> getCallingStatus({required String channelUid}) =>
      fireStoreCallingRoom.getCallingStatus(channelUid: channelUid);
  @override
  Future<String> joinToRoom(
      {required String channelId,
      required UserPersonalInfo myPersonalInfo}) async {
    try {
      return await fireStoreCallingRoom.joinToRoom(
          channelId: channelId, myPersonalInfo: myPersonalInfo);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> leaveTheRoom({
    required String userId,
    required String channelId,
    required bool isThatAfterJoining,
  }) async {
    try {
      await firestoreUser.cancelJoiningToRoom(userId);
      await fireStoreCallingRoom.removeThisUserFromRoom(
          channelId: channelId,
          userId: userId,
          isThatAfterJoining: isThatAfterJoining);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<List<UsersInfoInCallingRoom>> getUsersInfoInThisRoom(
      {required String channelId}) async {
    try {
      return await fireStoreCallingRoom.getUsersInfoInThisRoom(
          channelId: channelId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> deleteTheRoom(
      {required String channelId, required List<dynamic> usersIds}) async {
    try {
      await firestoreUser.clearChannelsIds(
          usersIds: usersIds, myPersonalId: myPersonalId);
      return await fireStoreCallingRoom.deleteTheRoom(channelId: channelId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
