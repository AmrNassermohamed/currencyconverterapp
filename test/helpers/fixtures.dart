import 'package:currencyconverterapp/features/currency/data/models/history_rate_model.dart';
import 'package:currencyconverterapp/features/currency/domain/entities/currency.dart';

class Fixtures {
  static const currencies = [
    Currency(id: "USD", name: "US Dollar", countryCode: "us"),
    Currency(id: "EGP", name: "Egyptian Pound", countryCode: "eg"),
    Currency(id: "EUR", name: "Euro", countryCode: "eu"),
  ];

  static final historyModels = [
    HistoryRateModel(date: "2025-12-22", rate: 49.2),
    HistoryRateModel(date: "2025-12-23", rate: 49.1),
  ];
}
