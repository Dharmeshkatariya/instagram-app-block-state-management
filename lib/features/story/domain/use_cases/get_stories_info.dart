import '../../../../core/usecase/usecase.dart';
import '../../../../models/user_personal_info.dart';
import '../repository/story_repo.dart';

class GetStoriesInfoUseCase
    implements UseCase<List<UserPersonalInfo>, List<dynamic>> {
  final FireStoreStoryRepository _getStoryRepository;

  GetStoriesInfoUseCase(this._getStoryRepository);

  @override
  Future<List<UserPersonalInfo>> call({required List<dynamic> params}) {
    return _getStoryRepository.getStoriesInfo(usersIds: params);
  }
}
