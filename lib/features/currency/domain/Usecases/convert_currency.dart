import '../../../../core/utils/resluts.dart';
import '../repositories/currency_repository.dart';

class ConvertCurrency {
  ConvertCurrency(this._repo);
  final CurrencyRepository _repo;

  Future<AppResult<double>> call({required String from, required String to}) =>
      _repo.getRate(from, to);
}
