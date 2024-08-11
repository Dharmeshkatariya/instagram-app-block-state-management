import 'package:dio/dio.dart';
import 'package:instagram_dharmesh_bloc_demo/core/enum/unknown_problem_type.dart';

import '../errors/client_failure.dart';
import 'client_exception_type.dart';
import 'dio_problem_type.dart';

enum ServerExceptionType {
  dioException('DIO_EXCEPTION', DioProblemType.values),
  unknownException('UNKNOWN_EXCEPTION', UnknownProblemType.values);

  final String name;

  final List<Enum> problemTypes;

  const ServerExceptionType(this.name, this.problemTypes);

  static ServerExceptionType? getServerExceptionByName(
      {required String? serverExceptionName}) {
    try {
      return values
          .firstWhere((element) => element.name == serverExceptionName);
    } catch (ex) {
      ClientFailure.createAndLog(
        stackTrace: StackTrace.current,
        exception: ex,
        clientExceptionType: ClientExceptionType.enumNotFoundError,
      );
    }
    return null;
  }

  /// Retrieves a problem type by its name.
  ///
  /// Returns `null` when the enum is not found.
  Enum? getProblemByName({required String? serverProblemName}) {
    try {
      return switch (this) {
        ServerExceptionType.unknownException =>
          UnknownProblemType.findByName(serverProblemName: serverProblemName),
        ServerExceptionType.dioException => DioExceptionType.values.firstWhere(
            (element) => element.name == serverProblemName,
            orElse: () => DioExceptionType.unknown),
      };
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
