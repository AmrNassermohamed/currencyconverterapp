import 'package:equatable/equatable.dart';

class Currency extends Equatable {
  final String id;
  final String name;
  final String? symbol;
  final String countryCode; // for flagcdn

  const Currency({
    required this.id,
    required this.name,
    required this.countryCode,
    this.symbol,
  });

  @override
  List<Object?> get props => [id, name, symbol, countryCode];
}
