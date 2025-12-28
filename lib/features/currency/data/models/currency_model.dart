import '../../domain/entities/currency.dart';

class CurrencyModel {
  final String id;
  final String currencyName;
  final String? currencySymbol;
  final String countryCode;

  CurrencyModel({
    required this.id,
    required this.currencyName,
    required this.countryCode,
    this.currencySymbol,
  });

  Map<String, dynamic> toJson() => {
    "id": id,
    "currencyName": currencyName,
    "currencySymbol": currencySymbol,
    "countryCode": countryCode,
  };

  factory CurrencyModel.fromJson(Map<String, dynamic> json) => CurrencyModel(
    id: json["id"],
    currencyName: json["currencyName"] ?? "",
    currencySymbol: json["currencySymbol"],
    countryCode: json["countryCode"] ?? "un",
  );

  Currency toEntity() => Currency(
    id: id,
    name: currencyName,
    symbol: currencySymbol,
    countryCode: countryCode,
  );
}
