import 'package:equatable/equatable.dart';

sealed class HistoryEvent extends Equatable {
  const HistoryEvent();
  @override
  List<Object?> get props => [];
}

class HistoryRequested extends HistoryEvent {
  final String from;
  final String to;

  const HistoryRequested({
    required this.from,
    required this.to,
  });

  @override
  List<Object?> get props => [from, to];
}
