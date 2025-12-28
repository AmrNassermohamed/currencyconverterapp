import 'package:bloc_test/bloc_test.dart';
import 'package:currencyconverterapp/core/utils/resluts.dart';
import 'package:currencyconverterapp/features/currency/data/models/history_rate_model.dart';
import 'package:currencyconverterapp/features/currency/domain/Usecases/GetHistory7Days.dart';
import 'package:currencyconverterapp/features/currency/presentation/bloc/history/history_bloc.dart';
import 'package:currencyconverterapp/features/currency/presentation/bloc/history/history_event.dart';
import 'package:currencyconverterapp/features/currency/presentation/bloc/history/history_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';




class MockGetHistory7Days extends Mock implements GetHistory7Days {}

void main() {
  late MockGetHistory7Days usecase;

  setUp(() => usecase = MockGetHistory7Days());

  blocTest<HistoryBloc, HistoryState>(
    'emits [loading, success] on success',
    build: () {
      when(() => usecase(from: "USD", to: "EGP")).thenAnswer(
            (_) async => Success([
           HistoryRateModel(date: "2025-12-22", rate: 49.2),
           HistoryRateModel(date: "2025-12-23", rate: 49.1),
        ]),
      );
      return HistoryBloc(usecase);
    },
    act: (bloc) => bloc.add(const HistoryRequested(from: "USD", to: "EGP")),
    expect: () => [
      isA<HistoryState>().having((s) => s.status, 'status', HistoryStatus.loading),
      isA<HistoryState>()
          .having((s) => s.status, 'status', HistoryStatus.success)
          .having((s) => s.rates.length, 'rates length', 2),
    ],
  );

  blocTest<HistoryBloc, HistoryState>(
    'emits [loading, failure] on failure',
    build: () {
      when(() => usecase(from: "USD", to: "EGP"))
          .thenAnswer((_) async => const Failure(AppFailure("error")));
      return HistoryBloc(usecase);
    },
    act: (bloc) => bloc.add(const HistoryRequested(from: "USD", to: "EGP")),
    expect: () => [
      isA<HistoryState>().having((s) => s.status, 'status', HistoryStatus.loading),
      isA<HistoryState>().having((s) => s.status, 'status', HistoryStatus.failure),
    ],
  );
}
