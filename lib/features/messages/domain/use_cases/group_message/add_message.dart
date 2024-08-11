import 'dart:io';
import 'dart:typed_data';

import '../../../../../core/usecase/usecase.dart';
import '../../../../../models/message.dart';
import '../../repository/group_message.dart';

class AddMessageForGroupChatUseCase
    implements UseCaseThreeParams<Message, Message, Uint8List, File?> {
  final FireStoreGroupMessageRepository _addPostToUserRepository;
  AddMessageForGroupChatUseCase(this._addPostToUserRepository);

  @override
  Future<Message> call(
      {required Message paramsOne,
      Uint8List? paramsTwo,
      required File? paramsThree}) {
    return _addPostToUserRepository.sendMessage(
        messageInfo: paramsOne,
        pathOfPhoto: paramsTwo,
        recordFile: paramsThree);
  }
}
