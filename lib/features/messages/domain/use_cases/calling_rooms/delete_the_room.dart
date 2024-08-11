import '../../../../../core/usecase/usecase.dart';
import '../../../../../models/user_personal_info.dart';
import '../../repository/calling_rooms_repository.dart';

class DeleteTheRoomUseCase
    extends UseCaseTwoParams<void, String, List<dynamic>> {
  final CallingRoomsRepository _callingRoomsRepo;
  DeleteTheRoomUseCase(this._callingRoomsRepo);
  @override
  Future<void> call(
      {required String paramsOne, required List<dynamic> paramsTwo}) async {
    return _callingRoomsRepo.deleteTheRoom(
        channelId: paramsOne, usersIds: paramsTwo);
  }
}
