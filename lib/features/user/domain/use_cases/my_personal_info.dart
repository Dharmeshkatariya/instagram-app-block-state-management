import '../../../../core/usecase/usecase.dart';
import '../../../../models/user_personal_info.dart';
import '../repository/user_repository.dart';

class GetMyInfoUseCase implements StreamUseCase<UserPersonalInfo, void> {
  final FireStoreUserRepository _getMyInfoRepository;

  GetMyInfoUseCase(this._getMyInfoRepository);

  @override
  Stream<UserPersonalInfo> call({required void params}) {
    return _getMyInfoRepository.getMyPersonalInfo();
  }
}
