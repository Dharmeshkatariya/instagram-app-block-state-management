import '../../../../core/usecase/usecase.dart';
import '../../../../models/notification.dart';
import '../repository/firestore_notification.dart';

class CreateNotificationUseCase implements UseCase<String, CustomNotification> {
  final FireStoreNotificationRepository _notificationRepository;
  CreateNotificationUseCase(this._notificationRepository);
  @override
  Future<String> call({required CustomNotification params}) {
    return _notificationRepository.createNotification(newNotification: params);
  }
}
