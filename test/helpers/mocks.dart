import 'package:currencyconverterapp/features/currency/domain/Usecases/GetHistory7Days.dart';
import 'package:currencyconverterapp/features/currency/domain/Usecases/convert_currency.dart';
import 'package:currencyconverterapp/features/currency/domain/Usecases/get_supported_currencies.dart';
import 'package:currencyconverterapp/features/currency/domain/repositories/currency_repository.dart';
import 'package:mocktail/mocktail.dart';


// Repo
class MockCurrencyRepository extends Mock implements CurrencyRepository {}

// UseCases (لو هتموكها في bloc tests)
class MockGetSupportedCurrencies extends Mock implements GetSupportedCurrencies {}
class MockConvertCurrency extends Mock implements ConvertCurrency {}
class MockGetHistory7Days extends Mock implements GetHistory7Days {}

