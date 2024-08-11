import 'package:equatable/equatable.dart';

import '../enum/client_exception_type.dart';

class ClientFailure extends ErrorFailure {
  final ClientExceptionType clientExceptionType;

  const ClientFailure({
    required super.stackTrace,
    super.exception,
    required this.clientExceptionType,
  });

  @override
  List<Object?> get props => [stackTrace, exception, clientExceptionType];

  @override
  ClientFailure copyWith({
    StackTrace? stackTrace,
    Object? exception,
    ClientExceptionType? clientExceptionType,
  }) {
    return ClientFailure(
      stackTrace: stackTrace ?? this.stackTrace,
      exception: exception ?? this.exception,
      clientExceptionType: clientExceptionType ?? this.clientExceptionType,
    );
  }

  /// Creates a [ClientFailure] and logs the failure.
  factory ClientFailure.createAndLog({
    required StackTrace stackTrace,
    required ClientExceptionType clientExceptionType,
    Object? exception,
  }) {
    final ClientFailure clientFailure = ClientFailure(
      stackTrace: stackTrace,
      exception: exception,
      clientExceptionType: clientExceptionType,
    );

    return clientFailure;
  }
}

class ErrorFailure extends Equatable implements Exception {
  final StackTrace stackTrace;
  final Object? exception;

  const ErrorFailure({
    required this.exception,
    required this.stackTrace,
  });

  @override
  List<Object?> get props => [stackTrace, exception];

  /// Creates a copy of this class.
  ErrorFailure copyWith({
    StackTrace? stackTrace,
    Object? exception,
  }) {
    return ErrorFailure(
      exception: exception ?? this.exception,
      stackTrace: stackTrace ?? this.stackTrace,
    );
  }
}
