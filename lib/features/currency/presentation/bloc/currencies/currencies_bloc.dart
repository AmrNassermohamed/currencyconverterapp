import 'package:bloc/bloc.dart';
import '../../../domain/entities/currency.dart';
import '../../../domain/usecases/get_supported_currencies.dart';
import 'currencies_event.dart';
import 'currencies_state.dart';

class CurrenciesBloc extends Bloc<CurrenciesEvent, CurrenciesState> {
  CurrenciesBloc(this._getSupportedCurrencies)
      : super(const CurrenciesState.initial()) {
    on<CurrenciesRequested>(_onRequested);
    on<CurrenciesSearchChanged>(_onSearchChanged);
  }

  final GetSupportedCurrencies _getSupportedCurrencies;

  Future<void> _onRequested(
      CurrenciesRequested event,
      Emitter<CurrenciesState> emit,
      ) async {
    emit(state.copyWith(status: CurrenciesStatus.loading, error: null));

    final res = await _getSupportedCurrencies(forceRefresh: event.forceRefresh);

    res.when(
      success: (list) {
        emit(
          state.copyWith(
            status: CurrenciesStatus.success,
            all: list,
            filtered: _applyFilter(list, state.query),
          ),
        );
      },
      failure: (f) {
        emit(state.copyWith(status: CurrenciesStatus.failure, error: f.message));
      },
    );
  }

  Future<void> _onSearchChanged(
      CurrenciesSearchChanged event,
      Emitter<CurrenciesState> emit,
      ) async {
    final q = event.query.trim().toLowerCase();
    emit(
      state.copyWith(
        query: q,
        filtered: _applyFilter(state.all, q),
      ),
    );
  }

  List<Currency> _applyFilter(List<Currency> list, String q) {
    if (q.isEmpty) return list;
    return list.where((c) {
      final s = "${c.id} ${c.name}".toLowerCase();
      return s.contains(q);
    }).toList();
  }
}
