import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/end_points.dart';
import '../../../../core/utils/resluts.dart';
import '../models/currency_model.dart';
import '../models/history_rate_model.dart';

class CurrencyRemoteDataSource {
  CurrencyRemoteDataSource(this._apiClient);
  final ApiClient _apiClient;

  Future<AppResult<List<CurrencyModel>>> fetchCurrencies() async {
    if (_apiClient.mockMode) {
      final s = await rootBundle.loadString("assets/mock/currencies.json");
      final data = jsonDecode(s) as Map<String, dynamic>;
      return Success(_parseCurrencies(data));
    }

    final res = await _apiClient.get(Endpoints.currencies);
    return res.when(
      success: (data) => Success(_parseCurrencies(data)),
      failure: (f) => Failure(f),
    );
  }

  List<CurrencyModel> _parseCurrencies(Map<String, dynamic> data) {
    final map = Map<String, dynamic>.from(data["results"] ?? {});
    return map.entries.map((e) {
      final v = Map<String, dynamic>.from(e.value);
      final code = (v["id"]?.toString() ?? e.key);
      return CurrencyModel(
        id: code,
        currencyName: v["currencyName"]?.toString() ?? "",
        currencySymbol: v["currencySymbol"]?.toString(),
        countryCode: _fallbackCountryCode(code),
      );
    }).toList();
  }

  String _fallbackCountryCode(String code) {
    switch (code.toUpperCase()) {
      case "USD":
        return "us";
      case "EUR":
        return "eu"; // لو حصل error هيتحول placeholder
      case "EGP":
        return "eg";
      case "GBP":
        return "gb";
      case "SAR":
        return "sa";
      default:
        return "un";
    }
  }

  Future<AppResult<double>> convert({required String from, required String to}) async {
    final pair = "${from}_$to";
    if (_apiClient.mockMode) return const Success(50.0);

    final res = await _apiClient.get(Endpoints.convert, query: {
      "q": pair,
      "compact": "ultra",
    });

    return res.when(
      success: (data) {
        final v = (data[pair] as num?)?.toDouble();
        if (v == null) return const Failure(AppFailure("Invalid convert response"));
        return Success(v);
      },
      failure: (f) => Failure(f),
    );
  }

  Future<AppResult<List<HistoryRateModel>>> history7Days({
    required String from,
    required String to,
    required String startDate,
    required String endDate,
  }) async {
    final pair = "${from}_$to";

    if (_apiClient.mockMode) {
      final s = await rootBundle.loadString("assets/mock/history.json");
      final data = jsonDecode(s) as Map<String, dynamic>;
      return Success(HistoryRateModel.fromRangeJson(pair, data));
    }

    final res = await _apiClient.get(Endpoints.convert, query: {
      "q": pair,
      "compact": "ultra",
      "date": startDate,
      "endDate": endDate,
    });

    return res.when(
      success: (data) => Success(HistoryRateModel.fromRangeJson(pair, data)),
      failure: (f) => Failure(f),
    );
  }
}
