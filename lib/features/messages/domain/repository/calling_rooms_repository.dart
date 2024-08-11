import '../../../../models/user_personal_info.dart';
import '../entities/calling_status.dart';

abstract class CallingRoomsRepository {
  Future<String> createCallingRoom(
      {required UserPersonalInfo myPersonalInfo,
      required List<UserPersonalInfo> callThoseUsersInfo});

  Stream<bool> getCallingStatus({required String channelUid});

  Future<String> joinToRoom(
      {required String channelId, required UserPersonalInfo myPersonalInfo});

  Future<void> leaveTheRoom({
    required String userId,
    required String channelId,
    required bool isThatAfterJoining,
  });

  Future<List<UsersInfoInCallingRoom>> getUsersInfoInThisRoom(
      {required String channelId});
  Future<void> deleteTheRoom(
      {required String channelId, required List<dynamic> usersIds});
}
