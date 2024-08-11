import '../../../../core/usecase/usecase.dart';
import '../../../../models/notification.dart';
import '../entities/notification_check.dart';
import '../repository/firestore_notification.dart';

class GetNotificationsUseCase
    implements UseCase<List<CustomNotification>, String> {
  final FireStoreNotificationRepository _notificationRepository;
  GetNotificationsUseCase(this._notificationRepository);
  @override
  Future<List<CustomNotification>> call({required String params}) {
    return _notificationRepository.getNotifications(userId: params);
  }
}
