import 'package:hive/hive.dart';
import '../../../../core/utils/resluts.dart';
import '../models/currency_model.dart';


class CurrencyLocalDataSource {
  static const boxName = "currencies_box";
  static const keyCurrencies = "currencies";

  Future<void> saveCurrencies(List<CurrencyModel> list) async {
    final box = await Hive.openBox(boxName);
    final jsonList = list.map((e) => e.toJson()).toList();
    await box.put(keyCurrencies, jsonList);
  }

  Future<AppResult<List<CurrencyModel>>> loadCurrencies() async {
    final box = await Hive.openBox(boxName);
    final raw = box.get(keyCurrencies);
    if (raw == null) return const Failure(AppFailure("No cached currencies"));
    final list = (raw as List)
        .map((e) => CurrencyModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    return Success(list);
  }
}
