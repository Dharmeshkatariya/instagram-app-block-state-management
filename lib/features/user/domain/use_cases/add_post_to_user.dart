import '../../../../core/usecase/usecase.dart';
import '../../../../models/post/post.dart';
import '../../../../models/user_personal_info.dart';
import '../repository/user_repository.dart';

class AddPostToUserUseCase
    implements UseCaseTwoParams<UserPersonalInfo, String, Post> {
  final FireStoreUserRepository _addPostToUserRepository;

  AddPostToUserUseCase(this._addPostToUserRepository);

  @override
  Future<UserPersonalInfo> call(
      {required String paramsOne, required Post paramsTwo}) {
    return _addPostToUserRepository.updateUserPostsInfo(
        userId: paramsOne, postInfo: paramsTwo);
  }
}
