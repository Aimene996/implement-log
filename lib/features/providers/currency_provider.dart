import 'package:flutter/material.dart';
import 'package:mactest/features/models/currency.dart';
import 'package:mactest/features/services/settings_helper.dart';

class CurrencyProvider extends ChangeNotifier {
  Currency _currency = Currency(code: 'USD', symbol: '\$', name: 'US Dollar');

  Currency get currency => _currency;

  CurrencyProvider() {
    _loadCurrency();
  }

  void _loadCurrency() async {
    _currency = await CurrencyService.getCurrency();
    notifyListeners();
  }

  void updateCurrency(Currency newCurrency) async {
    _currency = newCurrency;
    await CurrencyService.saveCurrency(newCurrency);
    notifyListeners();
  }
}
