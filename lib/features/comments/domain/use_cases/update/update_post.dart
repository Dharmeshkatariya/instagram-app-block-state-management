import '../../../../../../core/usecase/usecase.dart';
import '../../../../../../models/comment.dart';
import '../../../../../models/post/post.dart';
import '../../repository/firestore_comments_repository.dart';
import '../../repository/firestore_post_repository.dart';

class UpdatePostUseCase implements UseCase<Post, Post> {
  final FireStorePostRepository _updatePostRepository;

  UpdatePostUseCase(this._updatePostRepository);

  @override
  Future<Post> call({required Post params}) {
    return _updatePostRepository.updatePost(postInfo: params);
  }
}
