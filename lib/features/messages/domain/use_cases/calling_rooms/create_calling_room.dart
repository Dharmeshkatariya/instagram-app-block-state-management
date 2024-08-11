import '../../../../../core/usecase/usecase.dart';
import '../../../../../models/user_personal_info.dart';
import '../../repository/calling_rooms_repository.dart';

class CreateCallingRoomUseCase
    extends UseCaseTwoParams<String, UserPersonalInfo, List<UserPersonalInfo>> {
  final CallingRoomsRepository _callingRoomsRepo;
  CreateCallingRoomUseCase(this._callingRoomsRepo);
  @override
  Future<String> call(
      {required UserPersonalInfo paramsOne,
      required List<UserPersonalInfo> paramsTwo}) async {
    return await _callingRoomsRepo.createCallingRoom(
        myPersonalInfo: paramsOne, callThoseUsersInfo: paramsTwo);
  }
}
