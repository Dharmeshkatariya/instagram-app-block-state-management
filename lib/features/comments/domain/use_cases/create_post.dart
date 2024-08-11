import 'dart:typed_data';
import '../../../../../../core/usecase/usecase.dart';
import '../../../../../models/post/post.dart';
import '../entities/selected_bytes.dart';
import '../repository/firestore_post_repository.dart';
import 'package:image_picker_plus/image_picker_plus.dart';

class CreatePostUseCase
    implements UseCaseThreeParams<Post, Post, List<SelectedByte>, Uint8List?> {
  final FireStorePostRepository _createPostRepository;

  CreatePostUseCase(this._createPostRepository);

  @override
  Future<Post> call(
      {required Post paramsOne,
      required List<SelectedByte> paramsTwo,
      required Uint8List? paramsThree}) {
    return _createPostRepository.createPost(
        postInfo: paramsOne, files: paramsTwo, coverOfVideo: paramsThree);
  }
}
