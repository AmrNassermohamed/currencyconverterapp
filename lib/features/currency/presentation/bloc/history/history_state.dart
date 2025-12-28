import 'package:currencyconverterapp/features/currency/data/models/history_rate_model.dart';
import 'package:equatable/equatable.dart';


enum HistoryStatus { initial, loading, success, failure }

class HistoryState extends Equatable {
  final HistoryStatus status;
  final List<HistoryRateModel> rates;
  final String? error;

  const HistoryState({
    required this.status,
    required this.rates,
    this.error,
  });

  const HistoryState.initial()
      : status = HistoryStatus.initial,
        rates = const [],
        error = null;

  HistoryState copyWith({
    HistoryStatus? status,
    List<HistoryRateModel>? rates,
    String? error,
  }) {
    return HistoryState(
      status: status ?? this.status,
      rates: rates ?? this.rates,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, rates, error];
}
