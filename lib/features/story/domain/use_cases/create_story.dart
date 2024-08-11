import 'dart:typed_data';

import '../../../../core/usecase/usecase.dart';
import '../../../../models/post/story.dart';
import '../repository/story_repo.dart';

class CreateStoryUseCase implements UseCaseTwoParams<String, Story, Uint8List> {
  final FireStoreStoryRepository _createStoryRepository;

  CreateStoryUseCase(this._createStoryRepository);

  @override
  Future<String> call(
      {required Story paramsOne, required Uint8List paramsTwo}) {
    return _createStoryRepository.createStory(
        storyInfo: paramsOne, file: paramsTwo);
  }
}
