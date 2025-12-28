import 'package:bloc/bloc.dart';
import '../../../domain/usecases/convert_currency.dart';
import 'converter_state.dart';

class ConverterCubit extends Cubit<ConverterState> {
  ConverterCubit(this._convertCurrency) : super(const ConverterState.initial());

  final ConvertCurrency _convertCurrency;

  Future<void> submit({
    required String from,
    required String to,
    required double amount,
  }) async {
    if (amount <= 0) {
      emit(state.copyWith(status: ConverterStatus.failure, error: "Amount must be > 0"));
      return;
    }

    emit(state.copyWith(status: ConverterStatus.loading, error: null));
    final res = await _convertCurrency(from: from, to: to);

    res.when(
      success: (rate) => emit(
        state.copyWith(
          status: ConverterStatus.success,
          rate: rate,
          result: rate * amount,
        ),
      ),
      failure: (f) => emit(state.copyWith(status: ConverterStatus.failure, error: f.message)),
    );
  }

  void reset() => emit(const ConverterState.initial());
}
