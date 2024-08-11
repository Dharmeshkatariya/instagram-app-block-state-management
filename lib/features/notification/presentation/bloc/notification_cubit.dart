import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_dharmesh_bloc_demo/features/notification/domain/use_cases/create_notification_use_case.dart';
import 'package:instagram_dharmesh_bloc_demo/features/notification/domain/use_cases/delete_notification.dart';
import 'package:instagram_dharmesh_bloc_demo/features/notification/domain/use_cases/get_notifications_use_case.dart';
import 'package:instagram_dharmesh_bloc_demo/injection_container.dart';

import '../../../../models/notification.dart';
import '../../domain/entities/notification_check.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  // final GetNotificationsUseCase _getNotificationsUseCase;
  // final CreateNotificationUseCase _createNotificationUseCase;
  // final DeleteNotificationUseCase _deleteNotificationUseCase;
  NotificationCubit(
      // this._createNotificationUseCase,
      // this._getNotificationsUseCase, this._deleteNotificationUseCase
      )
      : super(NotificationInitial());

  static NotificationCubit get(BuildContext context) =>
      BlocProvider.of<NotificationCubit>(context);
  List<CustomNotification> notifications = [];
  Future<void> getNotifications({required String userId}) async {
    emit(NotificationLoading());
    await locator
        .call<GetNotificationsUseCase>()
        .call(params: userId)
        .then((List<CustomNotification> notifications) {
      this.notifications = notifications;
      emit(NotificationLoaded(notifications: notifications));
    }).catchError((e) {
      emit(NotificationFailed(e.toString()));
    });
  }

  Future<void> createNotification(
      {required CustomNotification newNotification}) async {
    await locator
        .call<CreateNotificationUseCase>()
        .call(params: newNotification)
        .then((notificationUid) {
      emit(NotificationCreated(notificationUid: notificationUid));
    }).catchError((e) {
      emit(NotificationFailed(e.toString()));
    });
  }

  deleteNotification({required NotificationCheck notificationCheck}) async {
    await locator
        .call<DeleteNotificationUseCase>()
        .call(params: notificationCheck)
        .then((_) {
      emit(NotificationDeleted());
    }).catchError((e) {
      emit(NotificationFailed(e.toString()));
    });
  }
}
