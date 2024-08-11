import '../../../../core/usecase/usecase.dart';
import '../../../../models/user_personal_info.dart';
import '../repository/user_repository.dart';

class SearchAboutUserUseCase
    implements StreamUseCaseTwoParams<List<UserPersonalInfo>, String, bool> {
  final FireStoreUserRepository _addPostToUserRepository;

  SearchAboutUserUseCase(this._addPostToUserRepository);

  @override
  Stream<List<UserPersonalInfo>> call(
      {required String paramsOne, required bool paramsTwo}) {
    return _addPostToUserRepository.searchAboutUser(
        name: paramsOne, searchForSingleLetter: paramsTwo);
  }
}
