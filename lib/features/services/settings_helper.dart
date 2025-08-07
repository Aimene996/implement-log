// lib/features/services/currency_service.dart
import 'package:hive/hive.dart';
import '../models/currency.dart';

class CurrencyService {
  static const String _boxName = 'currencyBox';
  static const String _currencyKey = 'selectedCurrency';

  static Future<void> saveCurrency(Currency currency) async {
    final box = await Hive.openBox<Currency>(_boxName);
    await box.put(_currencyKey, currency);
  }

  static Future<Currency> getCurrency() async {
    final box = await Hive.openBox<Currency>(_boxName);
    return box.get(_currencyKey) ??
        Currency(code: 'USD', symbol: '\$', name: 'US Dollar');
  }
}
