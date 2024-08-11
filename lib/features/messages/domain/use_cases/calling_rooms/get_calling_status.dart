import '../../../../../core/usecase/usecase.dart';
import '../../../../../models/user_personal_info.dart';
import '../../repository/calling_rooms_repository.dart';

class GetCallingStatusUseCase extends StreamUseCase<bool, String> {
  final CallingRoomsRepository _callingRoomsRepo;
  GetCallingStatusUseCase(this._callingRoomsRepo);
  @override
  Stream<bool> call({required String params}) {
    return _callingRoomsRepo.getCallingStatus(channelUid: params);
  }
}
