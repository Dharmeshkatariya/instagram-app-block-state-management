import '../../../../../models/post/story.dart';
import '../../../../../models/user_personal_info.dart';

abstract class FirebaseStoryNetworkDb {
  Future<String> createStory(Story postInfo);
  Future<void> deleteThisStory({required String storyId});
  Future<List<UserPersonalInfo>> getStoriesInfo(
      List<UserPersonalInfo> usersInfo);
}
