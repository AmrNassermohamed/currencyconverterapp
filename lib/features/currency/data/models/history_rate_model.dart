class HistoryRateModel {
  final String date; // yyyy-MM-dd
  final double rate;

  HistoryRateModel({required this.date, required this.rate});

  static List<HistoryRateModel> fromRangeJson(String pair, Map<String, dynamic> data) {
    // شكل response عادة: { "USD_EUR": { "2025-12-21": 0.9, ... } }
    final inner = (data[pair] as Map?) ?? {};
    final entries = inner.entries.toList()
      ..sort((a, b) => a.key.toString().compareTo(b.key.toString()));
    return entries.map((e) => HistoryRateModel(
      date: e.key.toString(),
      rate: (e.value as num).toDouble(),
    )).toList();
  }
}
