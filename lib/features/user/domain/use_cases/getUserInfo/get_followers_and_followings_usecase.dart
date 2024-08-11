import '../../../../../core/usecase/usecase.dart';
import '../../../../../models/user_personal_info.dart';
import '../../entities/specific_user.dart';
import '../../repository/user_repository.dart';

class GetFollowersAndFollowingsUseCase
    implements
        UseCaseTwoParams<FollowersAndFollowingsInfo, List<dynamic>,
            List<dynamic>> {
  final FireStoreUserRepository _fireStoreUserRepository;

  GetFollowersAndFollowingsUseCase(this._fireStoreUserRepository);

  @override
  Future<FollowersAndFollowingsInfo> call(
      {required List<dynamic> paramsOne, required List<dynamic> paramsTwo}) {
    return _fireStoreUserRepository.getFollowersAndFollowingsInfo(
        followersIds: paramsOne, followingsIds: paramsTwo);
  }
}
