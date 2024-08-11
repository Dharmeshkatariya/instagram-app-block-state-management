import 'dart:typed_data';

import '../../../../core/usecase/usecase.dart';
import '../repository/user_repository.dart';

class UploadProfileImageUseCase
    implements UseCaseThreeParams<String, Uint8List, String, String> {
  final FireStoreUserRepository _addNewUserRepository;

  UploadProfileImageUseCase(this._addNewUserRepository);

  @override
  Future<String> call(
      {required Uint8List paramsOne,
      required String paramsTwo,
      required String paramsThree}) {
    return _addNewUserRepository.uploadProfileImage(
        photo: paramsOne, userId: paramsTwo, previousImageUrl: paramsThree);
  }
}
