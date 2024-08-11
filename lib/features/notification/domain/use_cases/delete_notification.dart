import '../../../../core/usecase/usecase.dart';
import '../entities/notification_check.dart';
import '../repository/firestore_notification.dart';

class DeleteNotificationUseCase implements UseCase<void, NotificationCheck> {
  final FireStoreNotificationRepository _notificationRepository;
  DeleteNotificationUseCase(this._notificationRepository);
  @override
  Future<void> call({required NotificationCheck params}) {
    return _notificationRepository.deleteNotification(
        notificationCheck: params);
  }
}
