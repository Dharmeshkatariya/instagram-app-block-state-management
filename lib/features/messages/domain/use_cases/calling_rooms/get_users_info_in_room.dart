import '../../../../../core/usecase/usecase.dart';
import '../../../../../models/user_personal_info.dart';
import '../../entities/calling_status.dart';
import '../../repository/calling_rooms_repository.dart';

class GetUsersInfoInRoomUseCase
    extends UseCase<List<UsersInfoInCallingRoom>, String> {
  final CallingRoomsRepository _callingRoomsRepo;
  GetUsersInfoInRoomUseCase(this._callingRoomsRepo);
  @override
  Future<List<UsersInfoInCallingRoom>> call({required String params}) {
    return _callingRoomsRepo.getUsersInfoInThisRoom(channelId: params);
  }
}
