import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../models/post/story.dart';
import '../../../../../models/user_personal_info.dart';
import 'firebase_story_network_db.dart';

class FirebaseStoryNetworkDbImpl implements FirebaseStoryNetworkDb {
  static final _fireStoreStoryCollection =
      FirebaseFirestore.instance.collection('stories');
  @override
  Future<String> createStory(Story postInfo) async {
    DocumentReference<Map<String, dynamic>> postRef =
        await _fireStoreStoryCollection.add(postInfo.toMap());

    await _fireStoreStoryCollection
        .doc(postRef.id)
        .update({"storyUid": postRef.id});
    return postRef.id;
  }

  @override
  Future<void> deleteThisStory({required String storyId}) async {
    return await _fireStoreStoryCollection.doc(storyId).delete();
  }

  @override
  Future<List<UserPersonalInfo>> getStoriesInfo(
      List<UserPersonalInfo> usersInfo) async {
    List<Story> storiesInfo = [];
    List<String> storiesIds = [];
    for (int i = 0; i < usersInfo.length; i++) {
      storiesInfo = [];
      List<dynamic> userStories = usersInfo[i].stories;
      if (userStories.isEmpty) {
        usersInfo.removeAt(i);
        i--;
        continue;
      }
      for (int j = 0; j < userStories.length; j++) {
        DocumentSnapshot<Map<String, dynamic>> snap =
            await _fireStoreStoryCollection.doc(userStories[j]).get();
        if (snap.exists) {
          Story postReformat = Story.fromSnap(docSnap: snap);
          if (postReformat.storyUrl.isNotEmpty) {
            postReformat.publisherInfo = usersInfo[i];
            if (!storiesIds.contains(postReformat.storyUid)) {
              storiesInfo.add(postReformat);
              storiesIds.add(postReformat.storyUid);
            }
          }
        }
      }
      usersInfo[i].storiesInfo = storiesInfo;
    }
    return usersInfo;
  }
}
