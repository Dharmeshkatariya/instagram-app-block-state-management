import '../../../../../../core/usecase/usecase.dart';
import '../../../../../../models/comment.dart';
import '../../../../../models/post/post.dart';
import '../../repository/firestore_comments_repository.dart';
import '../../repository/firestore_post_repository.dart';

class GetSpecificUsersPostsUseCase implements UseCase<List, List<dynamic>> {
  final FireStorePostRepository _getSpecificUsersPostsRepository;

  GetSpecificUsersPostsUseCase(this._getSpecificUsersPostsRepository);

  @override
  Future<List> call({required List<dynamic> params}) {
    return _getSpecificUsersPostsRepository.getSpecificUsersPosts(params);
  }
}
