import 'package:dio/dio.dart';

import '../errors/client_failure.dart';
import 'client_exception_type.dart';

enum DioProblemType {
  connectionTimeout('CONNECTION_TIMEOUT'),
  sendTimeout('SEND_TIMEOUT'),
  receiveTimeout('RECEIVE_TIMEOUT'),
  badCertificate('BAD_CERTIFICATE'),
  badResponse('BAD_RESPONSE'),
  cancel('CANCEL'),
  connectionError('CONNECTION'),
  unknown('UNKNOWN');

  final String name;

  const DioProblemType(this.name);

  DioProblemType? findByDioException(
      {required DioExceptionType dioExceptionType}) {
    try {
      return values
          .firstWhere((element) => element.name == dioExceptionType.name);
    } catch (ex) {
      ClientFailure.createAndLog(
        stackTrace: StackTrace.current,
        exception: ex,
        clientExceptionType: ClientExceptionType.enumNotFoundError,
      );
    }
    return null;
  }
}
