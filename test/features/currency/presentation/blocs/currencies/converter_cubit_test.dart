import 'package:bloc_test/bloc_test.dart';
import 'package:currencyconverterapp/core/utils/resluts.dart';
import 'package:currencyconverterapp/features/currency/domain/usecases/get_supported_currencies.dart';
import 'package:currencyconverterapp/features/currency/domain/entities/currency.dart';
import 'package:currencyconverterapp/features/currency/presentation/bloc/currencies/currencies_bloc.dart';
import 'package:currencyconverterapp/features/currency/presentation/bloc/currencies/currencies_event.dart';
import 'package:currencyconverterapp/features/currency/presentation/bloc/currencies/currencies_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetSupportedCurrencies extends Mock implements GetSupportedCurrencies {}

void main() {
  late MockGetSupportedCurrencies usecase;

  setUp(() {
    usecase = MockGetSupportedCurrencies();
  });

  blocTest<CurrenciesBloc, CurrenciesState>(
    'emits [loading, success] with filtered list when requested',
    build: () {
      when(() => usecase(forceRefresh: false)).thenAnswer(
            (_) async => Success([
          const Currency(id: 'USD', name: 'Dollar', countryCode: 'us'),
          const Currency(id: 'EGP', name: 'Egyptian Pound', countryCode: 'eg'),
        ]),
      );
      return CurrenciesBloc(usecase);
    },
    act: (bloc) => bloc.add(const CurrenciesRequested(forceRefresh: false)),
    expect: () => [
      isA<CurrenciesState>().having((s) => s.status, 'status', CurrenciesStatus.loading),
      isA<CurrenciesState>()
          .having((s) => s.status, 'status', CurrenciesStatus.success)
          .having((s) => s.all.length, 'all length', 2)
          .having((s) => s.filtered.length, 'filtered length', 2),
    ],
  );

  blocTest<CurrenciesBloc, CurrenciesState>(
    'filters list when search changes',
    build: () {
      when(() => usecase(forceRefresh: false)).thenAnswer(
            (_) async => Success([
          const Currency(id: 'USD', name: 'Dollar', countryCode: 'us'),
          const Currency(id: 'EGP', name: 'Egyptian Pound', countryCode: 'eg'),
        ]),
      );
      return CurrenciesBloc(usecase);
    },
    act: (bloc) {
      bloc.add(const CurrenciesRequested());
      bloc.add(const CurrenciesSearchChanged("usd"));
    },
    wait: const Duration(milliseconds: 1),
    expect: () => [
      isA<CurrenciesState>().having((s) => s.status, 'status', CurrenciesStatus.loading),
      isA<CurrenciesState>().having((s) => s.status, 'status', CurrenciesStatus.success),
      isA<CurrenciesState>().having((s) => s.filtered.length, 'filtered length', 1),
    ],
  );

  blocTest<CurrenciesBloc, CurrenciesState>(
    'emits [loading, failure] on error',
    build: () {
      when(() => usecase(forceRefresh: false))
          .thenAnswer((_) async => const Failure(AppFailure("network error")));
      return CurrenciesBloc(usecase);
    },
    act: (bloc) => bloc.add(const CurrenciesRequested()),
    expect: () => [
      isA<CurrenciesState>().having((s) => s.status, 'status', CurrenciesStatus.loading),
      isA<CurrenciesState>()
          .having((s) => s.status, 'status', CurrenciesStatus.failure)
          .having((s) => s.error, 'error', "network error"),
    ],
  );
}
