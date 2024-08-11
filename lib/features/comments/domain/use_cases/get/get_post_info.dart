import '../../../../../../core/usecase/usecase.dart';
import '../../../../../../models/comment.dart';
import '../../../../../models/post/post.dart';
import '../../repository/firestore_comments_repository.dart';
import '../../repository/firestore_post_repository.dart';

class GetPostsInfoUseCase
    implements UseCaseTwoParams<List<Post>, List<dynamic>, int> {
  final FireStorePostRepository _getPostRepository;

  GetPostsInfoUseCase(this._getPostRepository);

  @override
  Future<List<Post>> call(
      {required List<dynamic> paramsOne, required int paramsTwo}) {
    return _getPostRepository.getPostsInfo(
        postsIds: paramsOne, lengthOfCurrentList: paramsTwo);
  }
}
