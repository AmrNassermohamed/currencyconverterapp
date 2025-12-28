import 'package:currencyconverterapp/core/utils/resluts.dart';
import 'package:currencyconverterapp/features/currency/data/models/history_rate_model.dart';
import '../repositories/currency_repository.dart';

class GetHistory7Days {
  GetHistory7Days(this._repo);
  final CurrencyRepository _repo;

  Future<AppResult<List<HistoryRateModel>>> call({required String from, required String to}) =>
      _repo.getHistory7Days(from, to);
}
