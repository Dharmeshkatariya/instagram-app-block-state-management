import '../../../../../../core/usecase/usecase.dart';
import '../../../../../../models/comment.dart';
import '../../../../../models/post/post.dart';
import '../../repository/firestore_comments_repository.dart';
import '../../repository/firestore_post_repository.dart';

class GetAllPostsInfoUseCase
    implements UseCaseTwoParams<List<Post>, bool, String> {
  final FireStorePostRepository _getPostRepository;

  GetAllPostsInfoUseCase(this._getPostRepository);

  @override
  Future<List<Post>> call(
      {required bool paramsOne, required String paramsTwo}) {
    return _getPostRepository.getAllPostsInfo(
        isVideosWantedOnly: paramsOne, skippedVideoUid: paramsTwo);
  }
}
