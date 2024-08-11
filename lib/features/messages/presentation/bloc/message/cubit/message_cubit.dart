import 'dart:io';
import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_dharmesh_bloc_demo/injection_container.dart';

import '../../../../../../models/message.dart';
import '../../../../../user/domain/entities/sender_info.dart';
import '../../../../domain/use_cases/common/get_specific_chat_info.dart';
import '../../../../domain/use_cases/single_message/add_message.dart';
import '../../../../domain/use_cases/single_message/delete_message.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  List<Message> messagesInfo = [];

  MessageCubit() : super(MessageInitial());

  static MessageCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> sendMessage({
    required Message messageInfo,
    Uint8List? pathOfPhoto,
    File? recordFile,
  }) async {
    emit(SendMessageLoading());
    await locator
        .call<AddMessageUseCase>()
        .call(
            paramsOne: messageInfo,
            paramsTwo: pathOfPhoto,
            paramsThree: recordFile)
        .then((messageInfo) {
      emit(SendMessageLoaded(messageInfo));
    }).catchError((e) {
      emit(SendMessageFailed(e.toString()));
    });
  }

  Future<void> getSpecificChatInfo(
      {required String chatUid, required bool isThatGroup}) async {
    emit(GetSpecificChatLoading());
    await locator
        .call<GetSpecificChatInfo>()
        .call(paramsOne: chatUid, paramsTwo: isThatGroup)
        .then((coverMessageDetails) {
      emit(GetSpecificChatLoaded(coverMessageDetails));
    }).catchError((e) {
      emit(GetMessageFailed(e.toString()));
    });
  }

  Future<void> deleteMessage({
    required Message messageInfo,
    Message? replacedMessage,
    bool isThatOnlyMessageInChat = false,
  }) async {
    emit(DeleteMessageLoading());
    await locator
        .call<DeleteMessageUseCase>()
        .call(
            paramsOne: messageInfo,
            paramsTwo: replacedMessage,
            paramsThree: isThatOnlyMessageInChat)
        .then((_) {
      emit(DeleteMessageLoaded());
    }).catchError((e) {
      emit(SendMessageFailed(e.toString()));
    });
  }
}
