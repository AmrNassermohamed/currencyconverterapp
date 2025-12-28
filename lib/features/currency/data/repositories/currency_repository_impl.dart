import 'package:currencyconverterapp/features/currency/data/models/history_rate_model.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/resluts.dart';
import '../../domain/entities/currency.dart';
import '../../domain/repositories/currency_repository.dart';
import '../datasources/currency_local_ds.dart';
import '../datasources/currency_remote_ds.dart';
import '../models/currency_model.dart';

class CurrencyRepositoryImpl implements CurrencyRepository {
  CurrencyRepositoryImpl(this._remote, this._local);

  final CurrencyRemoteDataSource _remote;
  final CurrencyLocalDataSource _local;

  @override
  Future<AppResult<List<Currency>>> getSupportedCurrencies({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cached = await _local.loadCurrencies();
      final cachedMapped = cached.when(
        success: (list) => Success(list.map((e) => e.toEntity()).toList()),
        failure: (f) => Failure<List<Currency>>(f),
      );
      if (cachedMapped is Success<List<Currency>>) return cachedMapped;
    }

    final remote = await _remote.fetchCurrencies();
    return remote.when(
      success: (list) async {
        await _local.saveCurrencies(list);
        return Success(list.map((e) => e.toEntity()).toList());
      },
      failure: (f) => Failure(f),
    );
  }

  @override
  Future<AppResult<double>> getRate(String from, String to) => _remote.convert(from: from, to: to);

  @override
  Future<AppResult<List<HistoryRateModel>>> getHistory7Days(String from, String to) async {
    final now = DateTime.now();
    final end = DateTime(now.year, now.month, now.day);
    final start = end.subtract(const Duration(days: 6));
    final fmt = DateFormat("yyyy-MM-dd");

    final res = await _remote.history7Days(
      from: from,
      to: to,
      startDate: fmt.format(start),
      endDate: fmt.format(end),
    );

    return res.when(
      success: (list) => Success(list.map((e) => HistoryRateModel(date: e.date, rate: e.rate)).toList()),
      failure: (f) => Failure(f),
    );
  }
}
