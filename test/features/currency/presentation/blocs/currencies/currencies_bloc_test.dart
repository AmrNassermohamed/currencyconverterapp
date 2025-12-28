import 'package:bloc_test/bloc_test.dart';
import 'package:currencyconverterapp/core/utils/resluts.dart';
import 'package:currencyconverterapp/features/currency/domain/usecases/convert_currency.dart';
import 'package:currencyconverterapp/features/currency/presentation/bloc/converter/converter_cubit.dart';
import 'package:currencyconverterapp/features/currency/presentation/bloc/converter/converter_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockConvertCurrency extends Mock implements ConvertCurrency {}

void main() {
  late MockConvertCurrency usecase;

  setUp(() => usecase = MockConvertCurrency());

  blocTest<ConverterCubit, ConverterState>(
    'emits failure if amount <= 0',
    build: () => ConverterCubit(usecase),
    act: (cubit) => cubit.submit(from: "USD", to: "EGP", amount: 0),
    expect: () => [
      isA<ConverterState>().having((s) => s.status, 'status', ConverterStatus.failure),
    ],
  );

  blocTest<ConverterCubit, ConverterState>(
    'emits [loading, success] on success',
    build: () {
      when(() => usecase(from: "USD", to: "EGP"))
          .thenAnswer((_) async => const Success(50.0));
      return ConverterCubit(usecase);
    },
    act: (cubit) => cubit.submit(from: "USD", to: "EGP", amount: 2),
    expect: () => [
      isA<ConverterState>().having((s) => s.status, 'status', ConverterStatus.loading),
      isA<ConverterState>()
          .having((s) => s.status, 'status', ConverterStatus.success)
          .having((s) => s.rate, 'rate', 50.0)
          .having((s) => s.result, 'result', 100.0),
    ],
  );

  blocTest<ConverterCubit, ConverterState>(
    'emits [loading, failure] on failure',
    build: () {
      when(() => usecase(from: "USD", to: "EGP"))
          .thenAnswer((_) async => const Failure(AppFailure("error")));
      return ConverterCubit(usecase);
    },
    act: (cubit) => cubit.submit(from: "USD", to: "EGP", amount: 2),
    expect: () => [
      isA<ConverterState>().having((s) => s.status, 'status', ConverterStatus.loading),
      isA<ConverterState>().having((s) => s.status, 'status', ConverterStatus.failure),
    ],
  );
}
