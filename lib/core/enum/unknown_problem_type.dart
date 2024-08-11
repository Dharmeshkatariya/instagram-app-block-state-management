import '../errors/client_failure.dart';
import 'client_exception_type.dart';

enum UnknownProblemType {
  nullResponseValueError('NULL_RESPONSE_VALUE_ERROR'),
  unknownException('UNKNOWN_EXCEPTION');

  final String name;

  const UnknownProblemType(this.name);

  static UnknownProblemType? findByName({required String? serverProblemName}) {
    try {
      return values.firstWhere((element) => element.name == serverProblemName);
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
