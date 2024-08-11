import '../../../../../core/usecase/usecase.dart';
import '../../../../../models/user_personal_info.dart';
import '../../entities/calling_status.dart';
import '../../repository/calling_rooms_repository.dart';

class JoinToCallingRoomUseCase
    extends UseCaseTwoParams<String, String, UserPersonalInfo> {
  final CallingRoomsRepository _callingRoomsRepo;
  JoinToCallingRoomUseCase(this._callingRoomsRepo);
  @override
  Future<String> call(
      {required String paramsOne, required UserPersonalInfo paramsTwo}) async {
    return await _callingRoomsRepo.joinToRoom(
        channelId: paramsOne, myPersonalInfo: paramsTwo);
  }
}
