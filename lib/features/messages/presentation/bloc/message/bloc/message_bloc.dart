import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_dharmesh_bloc_demo/injection_container.dart';
import '../../../../../../models/message.dart';
import '../../../../domain/use_cases/group_message/get_messages.dart';
import '../../../../domain/use_cases/single_message/get_messages.dart';
part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageBlocState> {
  MessageBloc() : super(MessageBlocInitial());

  Stream<MessageBlocState> mapEventToState(
    MessageEvent event,
  ) async* {
    if (event is LoadMessagesForSingleChat) {
      yield* _mapLoadMessagesToState(event.receiverId);
    } else if (event is UpdateMessages) {
      yield* _mapUpdateMessagesToState(event);
    }
    if (event is LoadMessagesForGroupChat) {
      yield* _mapLoadMessagesForGroupToState(event.groupChatUid);
    } else if (event is UpdateMessagesForGroup) {
      yield* _mapUpdateMessagesForGroupToState(event);
    }
  }

  static MessageBloc get(BuildContext context) => BlocProvider.of(context);

  Stream<MessageBlocState> _mapLoadMessagesToState(String receiverId) async* {
    locator.call<GetMessagesUseCase>().call(params: receiverId).listen(
      (messages) {
        add(UpdateMessages(messages));
      },
    );
  }

  Stream<MessageBlocState> _mapUpdateMessagesToState(
      UpdateMessages event) async* {
    yield MessageBlocLoaded(messages: event.messages);
  }

  Stream<MessageBlocState> _mapLoadMessagesForGroupToState(
      String groupChatUid) async* {
    locator
        .call<GetMessagesGroGroupChatUseCase>()
        .call(params: groupChatUid)
        .listen(
      (messages) {
        add(UpdateMessagesForGroup(messages));
      },
    );
  }

  Stream<MessageBlocState> _mapUpdateMessagesForGroupToState(
      UpdateMessagesForGroup event) async* {
    yield MessageBlocLoaded(messages: event.messages);
  }
}
