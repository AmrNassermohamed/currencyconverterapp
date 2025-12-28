import 'package:currencyconverterapp/features/currency/data/models/history_rate_model.dart';

import '../../../../core/utils/resluts.dart';

import '../entities/currency.dart';


abstract class CurrencyRepository {
  Future<AppResult<List<Currency>>> getSupportedCurrencies({bool forceRefresh = false});
  Future<AppResult<double>> getRate(String from, String to);
  Future<AppResult<List<HistoryRateModel>>> getHistory7Days(String from, String to);
}
