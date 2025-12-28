import 'package:equatable/equatable.dart';

enum ConverterStatus { initial, loading, success, failure }

class ConverterState extends Equatable {
  final ConverterStatus status;
  final double? rate;
  final double? result;
  final String? error;

  const ConverterState({
    required this.status,
    this.rate,
    this.result,
    this.error,
  });

  const ConverterState.initial() : this(status: ConverterStatus.initial);

  ConverterState copyWith({
    ConverterStatus? status,
    double? rate,
    double? result,
    String? error,
  }) {
    return ConverterState(
      status: status ?? this.status,
      rate: rate ?? this.rate,
      result: result ?? this.result,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, rate, result, error];
}
