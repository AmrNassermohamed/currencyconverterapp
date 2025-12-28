import 'package:equatable/equatable.dart';

sealed class AppResult<T> {
  const AppResult();
  R when<R>({required R Function(T data) success, required R Function(AppFailure f) failure});
}

class Success<T> extends AppResult<T> {
  final T data;
  const Success(this.data);
  @override
  R when<R>({required R Function(T) success, required R Function(AppFailure) failure}) => success(data);
}

class Failure<T> extends AppResult<T> {
  final AppFailure failureValue;
  const Failure(this.failureValue);
  @override
  R when<R>({required R Function(T) success, required R Function(AppFailure) failure}) => failure(failureValue);
}

class AppFailure extends Equatable {
  final String message;
  const AppFailure(this.message);
  @override
  List<Object?> get props => [message];
}
