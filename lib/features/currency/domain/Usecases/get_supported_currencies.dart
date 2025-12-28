
import '../../../../core/utils/resluts.dart';
import '../entities/currency.dart';
import '../repositories/currency_repository.dart';

class GetSupportedCurrencies {
  GetSupportedCurrencies(this._repo);
  final CurrencyRepository _repo;

  Future<AppResult<List<Currency>>> call({bool forceRefresh = false}) =>
      _repo.getSupportedCurrencies(forceRefresh: forceRefresh);
}
