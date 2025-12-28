import 'package:bloc/bloc.dart';

import '../../../domain/Usecases/GetHistory7Days.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc(this._getHistory7Days) : super(const HistoryState.initial()) {
    on<HistoryRequested>(_onRequested);
  }

  final GetHistory7Days _getHistory7Days;

  Future<void> _onRequested(
      HistoryRequested event,
      Emitter<HistoryState> emit,
      ) async {
    emit(state.copyWith(status: HistoryStatus.loading, error: null));

    final res = await _getHistory7Days(from: event.from, to: event.to);

    res.when(
      success: (list) => emit(
        state.copyWith(
          status: HistoryStatus.success,
          rates: list,
        ),
      ),
      failure: (f) => emit(
        state.copyWith(
          status: HistoryStatus.failure,
          error: f.message,
        ),
      ),
    );
  }
}
