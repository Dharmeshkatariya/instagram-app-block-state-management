import '../../../../../../core/usecase/usecase.dart';
import '../../../../../../models/comment.dart';
import '../../../../../models/post/post.dart';
import '../../repository/firestore_comments_repository.dart';
import '../../repository/firestore_post_repository.dart';

class DeletePostUseCase implements UseCase<void, Post> {
  final FireStorePostRepository _deletePostRepository;

  DeletePostUseCase(this._deletePostRepository);

  @override
  Future<void> call({required Post params}) {
    return _deletePostRepository.deletePost(postInfo: params);
  }
}
