import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_dharmesh_bloc_demo/injection_container.dart';
import 'dart:io';
import 'dart:typed_data';
import '../../../../../../../models/message.dart';
import '../../../../../domain/use_cases/group_message/add_message.dart';
import '../../../../../domain/use_cases/group_message/delete_message.dart';
part 'message_for_group_chat_state.dart';

class MessageForGroupChatCubit extends Cubit<MessageForGroupChatState> {
  MessageForGroupChatCubit() : super(MessageForGroupChatInitial());

  late Message lastMessage;

  static MessageForGroupChatCubit get(BuildContext context) =>
      BlocProvider.of(context);

  static Message getLastMessage(BuildContext context) =>
      BlocProvider.of<MessageForGroupChatCubit>(context).lastMessage;

  Future<void> sendMessage(
      {required Message messageInfo,
      Uint8List? pathOfPhoto,
      File? recordFile}) async {
    emit(MessageForGroupChatLoading());
    await locator
        .call<AddMessageForGroupChatUseCase>()
        .call(
            paramsOne: messageInfo,
            paramsTwo: pathOfPhoto,
            paramsThree: recordFile)
        .then((messageInfo) {
      lastMessage = messageInfo;
      emit(MessageForGroupChatLoaded(messageInfo));
    }).catchError((e) {
      emit(MessageForGroupChatFailed(e.toString()));
    });
  }

  Future<void> deleteMessage({
    required Message messageInfo,
    required String chatOfGroupUid,
    Message? replacedMessage,
  }) async {
    emit(DeleteMessageForGroupChatLoading());
    await locator
        .call<DeleteMessageForGroupChatUseCase>()
        .call(
            paramsOne: chatOfGroupUid,
            paramsTwo: messageInfo,
            paramsThree: replacedMessage)
        .then((_) {
      emit(DeleteMessageForGroupChatLoaded());
    }).catchError((e) {
      emit(MessageForGroupChatFailed(e.toString()));
    });
  }
}
