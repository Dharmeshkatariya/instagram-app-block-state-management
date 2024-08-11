import '../../../../core/usecase/usecase.dart';
import '../repository/story_repo.dart';

class DeleteStoryUseCase implements UseCase<void, String> {
  final FireStoreStoryRepository _getStoryRepository;

  DeleteStoryUseCase(this._getStoryRepository);

  @override
  Future<void> call({required String params}) {
    return _getStoryRepository.deleteThisStory(storyId: params);
  }
}
