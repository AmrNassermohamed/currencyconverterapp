import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/currency/domain/Usecases/GetHistory7Days.dart';
import '../network/api_client.dart';
import '../network/end_points.dart';

// Data
import '../../features/currency/data/datasources/currency_local_ds.dart';
import '../../features/currency/data/datasources/currency_remote_ds.dart';
import '../../features/currency/data/repositories/currency_repository_impl.dart';

// Domain
import '../../features/currency/domain/repositories/currency_repository.dart';
import '../../features/currency/domain/usecases/convert_currency.dart';

import '../../features/currency/domain/usecases/get_supported_currencies.dart';

// Presentation
import '../../features/currency/presentation/bloc/converter/converter_cubit.dart';
import '../../features/currency/presentation/bloc/currencies/currencies_bloc.dart';
import '../../features/currency/presentation/bloc/history/history_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // ✅ prevent double registration (Hot Restart / calling twice)
  if (getIt.isRegistered<Dio>()) return;

  const apiKey = String.fromEnvironment("API_KEY", defaultValue: "YOUR_API_KEY");
  const mockMode = bool.fromEnvironment("MOCK", defaultValue: false);

  // Core
  getIt.registerLazySingleton<Dio>(() => Dio(
    BaseOptions(
      baseUrl: Endpoints.baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    ),
  ));

  getIt.registerLazySingleton<ApiClient>(() => ApiClient(
    getIt<Dio>(),
    apiKey: apiKey,
    mockMode: mockMode,
  ));

  // Data sources
  getIt.registerLazySingleton<CurrencyLocalDataSource>(() => CurrencyLocalDataSource());
  getIt.registerLazySingleton<CurrencyRemoteDataSource>(() => CurrencyRemoteDataSource(getIt<ApiClient>()));

  // Repository
  getIt.registerLazySingleton<CurrencyRepository>(() => CurrencyRepositoryImpl(
    getIt<CurrencyRemoteDataSource>(),
    getIt<CurrencyLocalDataSource>(),
  ));

  // Use cases
  getIt.registerLazySingleton<GetSupportedCurrencies>(() => GetSupportedCurrencies(getIt<CurrencyRepository>()));
  getIt.registerLazySingleton<ConvertCurrency>(() => ConvertCurrency(getIt<CurrencyRepository>()));
  getIt.registerLazySingleton<GetHistory7Days>(() => GetHistory7Days(getIt<CurrencyRepository>()));

  // Blocs / Cubits
  getIt.registerFactory<CurrenciesBloc>(() => CurrenciesBloc(getIt<GetSupportedCurrencies>()));
  getIt.registerFactory<ConverterCubit>(() => ConverterCubit(getIt<ConvertCurrency>()));
  getIt.registerFactory<HistoryBloc>(() => HistoryBloc(getIt<GetHistory7Days>()));
}
