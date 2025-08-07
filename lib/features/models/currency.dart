// lib/features/models/currency.dart
import 'package:hive/hive.dart';

part 'currency.g.dart';

@HiveType(typeId: 2)
class Currency extends HiveObject {
  @HiveField(0)
  final String code; // USD
  @HiveField(1)
  final String symbol; // $
  @HiveField(2)
  final String name; // US Dollar

  Currency({required this.code, required this.symbol, required this.name});
}
