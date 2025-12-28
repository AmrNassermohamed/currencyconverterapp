import 'package:equatable/equatable.dart';
import '../../../domain/entities/currency.dart';

enum CurrenciesStatus { initial, loading, success, failure }

class CurrenciesState extends Equatable {
  final CurrenciesStatus status;
  final List<Currency> all;
  final List<Currency> filtered;
  final String query;
  final String? error;

  const CurrenciesState({
    required this.status,
    required this.all,
    required this.filtered,
    required this.query,
    this.error,
  });

  const CurrenciesState.initial()
      : status = CurrenciesStatus.initial,
        all = const [],
        filtered = const [],
        query = '',
        error = null;

  CurrenciesState copyWith({
    CurrenciesStatus? status,
    List<Currency>? all,
    List<Currency>? filtered,
    String? query,
    String? error,
  }) {
    return CurrenciesState(
      status: status ?? this.status,
      all: all ?? this.all,
      filtered: filtered ?? this.filtered,
      query: query ?? this.query,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, all, filtered, query, error];
}
