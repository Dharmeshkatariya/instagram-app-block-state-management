import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_dharmesh_bloc_demo/features/messages/domain/entities/calling_status.dart';

import '../../../../../../models/user_personal_info.dart';
import 'calling_room_network_db.dart';

class CallingRoomNetworkDbImpl implements CallingRoomNetworkDb {
  static final _roomsCollection =
      FirebaseFirestore.instance.collection('callingRooms');

  @override
  Future<String> createCallingRoom(
      {required UserPersonalInfo myPersonalInfo,
      required int initialNumberOfUsers}) async {
    DocumentReference<Map<String, dynamic>> collection =
        await _roomsCollection.add(
            _toMap(myPersonalInfo, initialNumberOfUsers: initialNumberOfUsers));

    _roomsCollection.doc(collection.id).update({"channelId": collection.id});
    return collection.id;
  }

  static Map<String, dynamic> _toMap(UserPersonalInfo myPersonalInfo,
          {int numberOfUsers = 1, int initialNumberOfUsers = 0}) =>
      {
        "numbersOfUsersInRoom": numberOfUsers,
        if (initialNumberOfUsers != 0)
          "initialNumberOfUsers": initialNumberOfUsers,
        "usersInfo": {
          "${myPersonalInfo.userId}": {
            "name": myPersonalInfo.name,
            "profileImage": myPersonalInfo.profileImageUrl
          }
        }
      };
  @override
  Stream<bool> getCallingStatus({required String channelUid}) {
    Stream<DocumentSnapshot<Map<String, dynamic>>> snapSearch =
        _roomsCollection.doc(channelUid).snapshots();
    return snapSearch.map((snapshot) {
      int initialNumberOfUsers = snapshot.get("initialNumberOfUsers");
      return initialNumberOfUsers != 1;
    });
  }

  @override
  Future<List<UsersInfoInCallingRoom>> getUsersInfoInThisRoom(
      {required String channelId}) async {
    DocumentSnapshot<Map<String, dynamic>> snap =
        await _roomsCollection.doc(channelId).get();
    Map<String, dynamic>? data = snap.data();
    List<UsersInfoInCallingRoom> usersInfo = [];
    data?.forEach((key, value) {
      if (key == "usersInfo") {
        Map map = value;
        map.forEach((userId, value) {
          Map secondMap = value;
          usersInfo.add(UsersInfoInCallingRoom(
            userId: userId,
            name: secondMap["name"],
            profileImageUrl: secondMap["profileImage"],
          ));
        });
      }
    });
    return usersInfo;
  }

  @override
  Future<String> joinToRoom(
      {required String channelId,
      required UserPersonalInfo myPersonalInfo}) async {
    DocumentSnapshot<Map<String, dynamic>> snap =
        await _roomsCollection.doc(channelId).get();
    int numbersOfUsers = snap.get("numbersOfUsersInRoom");
    _roomsCollection
        .doc(channelId)
        .update(_toMap(myPersonalInfo, numberOfUsers: numbersOfUsers + 1));
    return channelId;
  }

  @override
  Future<void> removeThisUserFromRoom(
      {required String userId,
      required String channelId,
      required bool isThatAfterJoining}) async {
    DocumentSnapshot<Map<String, dynamic>> snap =
        await _roomsCollection.doc(channelId).get();
    int initialNumberOfUsers = snap.get("initialNumberOfUsers");
    int numbersOfUsersInRoom = snap.get("numbersOfUsersInRoom");

    dynamic usersInfo = snap.get("usersInfo");
    usersInfo.removeWhere((key, value) {
      if (key == "usersInfo") {
        value.removeWhere((key, value) => key == userId);
        return false;
      } else {
        return false;
      }
    });
    _roomsCollection.doc(channelId).update({
      "usersInfo": usersInfo,
      "initialNumberOfUsers": initialNumberOfUsers - 1,
      if (isThatAfterJoining) "numbersOfUsersInRoom": numbersOfUsersInRoom - 1,
    });
  }

  @override
  Future<void> deleteTheRoom({required String channelId}) async {
    await _roomsCollection.doc(channelId).delete();
  }
}
