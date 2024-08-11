import '../../../../core/usecase/usecase.dart';
import '../../../../models/user_personal_info.dart';
import '../repository/story_repo.dart';

class GetSpecificStoriesInfoUseCase
    implements UseCase<UserPersonalInfo, UserPersonalInfo> {
  final FireStoreStoryRepository _getStoryRepository;

  GetSpecificStoriesInfoUseCase(this._getStoryRepository);

  @override
  Future<UserPersonalInfo> call({required UserPersonalInfo params}) {
    return _getStoryRepository.getSpecificStoriesInfo(userInfo: params);
  }
}
