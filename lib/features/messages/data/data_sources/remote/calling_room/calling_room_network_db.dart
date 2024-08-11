import '../../../../../../models/user_personal_info.dart';
import '../../../../domain/entities/calling_status.dart';

abstract class CallingRoomNetworkDb {
  Future<String> createCallingRoom(
      {required UserPersonalInfo myPersonalInfo,
      required int initialNumberOfUsers});

  Future<void> removeThisUserFromRoom({
    required String userId,
    required String channelId,
    required bool isThatAfterJoining,
  });

  Future<String> joinToRoom(
      {required String channelId, required UserPersonalInfo myPersonalInfo});

  Stream<bool> getCallingStatus({required String channelUid});

  Future<List<UsersInfoInCallingRoom>> getUsersInfoInThisRoom(
      {required String channelId});

  Future<void> deleteTheRoom({required String channelId});
}
