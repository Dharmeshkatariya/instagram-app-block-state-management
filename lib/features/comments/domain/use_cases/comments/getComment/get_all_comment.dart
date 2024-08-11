import '../../../../../../core/usecase/usecase.dart';
import '../../../../../../models/comment.dart';
import '../../../repository/firestore_comments_repository.dart';

class GetSpecificCommentsUseCase implements UseCase<List<Comment>, String> {
  final FireStoreCommentRepository _getAllCommentsRepository;

  GetSpecificCommentsUseCase(this._getAllCommentsRepository);

  @override
  Future<List<Comment>> call({required String params}) {
    return _getAllCommentsRepository.getSpecificComments(postId: params);
  }
}
