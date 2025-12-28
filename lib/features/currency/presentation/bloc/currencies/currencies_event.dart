import 'package:equatable/equatable.dart';

sealed class CurrenciesEvent extends Equatable {
  const CurrenciesEvent();
  @override
  List<Object?> get props => [];
}

class CurrenciesRequested extends CurrenciesEvent {
  final bool forceRefresh;
  const CurrenciesRequested({this.forceRefresh = false});

  @override
  List<Object?> get props => [forceRefresh];
}

class CurrenciesSearchChanged extends CurrenciesEvent {
  final String query;
  const CurrenciesSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}
