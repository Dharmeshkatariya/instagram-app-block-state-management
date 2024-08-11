import 'dart:typed_data';
import '../../../../core/constants/constants.dart';
import '../../../../models/post/story.dart';
import '../../../../models/user_personal_info.dart';
import '../../../auth/data/data_sources/remote/firebase_storage.dart';
import '../../../user/data/data_sources/remote/firestore_user_network_db_impl.dart';
import '../../domain/repository/story_repo.dart';
import '../data_sources/remote/firebase_story_network_db.dart';

class FireStoreStoryRepositoryImpl implements FireStoreStoryRepository {
  final FirebaseStoryNetworkDb fireStoreStory;
  FireStoreStoryRepositoryImpl({required this.fireStoreStory});

  final fireStoreUser = FireStoreUserNetworkDbImpl();
  @override
  Future<String> createStory(
      {required Story storyInfo, required Uint8List file}) async {
    try {
      String fileName = storyInfo.isThatImage ? "jpg" : "mp4";

      String postUrl = await FirebaseStoragePost.uploadData(
          data: file, folderName: fileName);
      storyInfo.storyUrl = postUrl;
      String storyUid = await fireStoreStory.createStory(storyInfo);
      await fireStoreUser.updateUserStories(
          userId: storyInfo.publisherId, storyId: storyUid);
      return storyUid;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<List<UserPersonalInfo>> getStoriesInfo(
      {required List<dynamic> usersIds}) async {
    try {
      List<UserPersonalInfo> usersInfo =
          await fireStoreUser.getSpecificUsersInfo(
              usersIds: usersIds, userUid: myPersonalId, fieldName: 'stories');
      return await fireStoreStory.getStoriesInfo(usersInfo);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<UserPersonalInfo> getSpecificStoriesInfo(
      {required UserPersonalInfo userInfo}) async {
    try {
      return (await fireStoreStory.getStoriesInfo([userInfo]))[0];
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> deleteThisStory({required String storyId}) async {
    try {
      await fireStoreUser.deleteThisStory(storyId: storyId);
      await fireStoreStory.deleteThisStory(storyId: storyId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
