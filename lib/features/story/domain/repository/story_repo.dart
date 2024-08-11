import 'dart:typed_data';

import '../../../../models/post/story.dart';
import '../../../../models/user_personal_info.dart';

abstract class FireStoreStoryRepository {
  Future<String> createStory(
      {required Story storyInfo, required Uint8List file});
  Future<List<UserPersonalInfo>> getStoriesInfo(
      {required List<dynamic> usersIds});
  Future<UserPersonalInfo> getSpecificStoriesInfo(
      {required UserPersonalInfo userInfo});
  Future<void> deleteThisStory({required String storyId});
}
