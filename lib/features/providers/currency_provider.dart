import 'package:flutter/material.dart';
import 'package:mactest/features/models/currency.dart';
import 'package:mactest/features/services/settings_helper.dart';
import 'package:mactest/features/services/exchange_rate_service.dart';

class CurrencyProvider extends ChangeNotifier {
  Currency _currency = Currency(code: 'USD', symbol: '\$', name: 'US Dollar');
  String _baseCode = 'USD';
  double _rateFromBase = 1.0; // base -> current currency

  Currency get currency => _currency;
  String get baseCode => _baseCode;
  double get rateFromBase => _rateFromBase;

  // Convert an amount stored in base currency to the selected display currency
  double toDisplay(double amountInBase) => amountInBase * _rateFromBase;

  CurrencyProvider() {
    _loadCurrency();
  }

  void _loadCurrency() async {
    _currency = await CurrencyService.getCurrency();
    await _refreshRate();
    notifyListeners();
  }

  Future<void> updateCurrency(Currency newCurrency) async {
    _currency = newCurrency;
    await CurrencyService.saveCurrency(newCurrency);
    await _refreshRate();
    notifyListeners();
  }

  Future<void> _refreshRate() async {
    try {
      _rateFromBase = await ExchangeRateService.fetchRate(
        from: _baseCode,
        to: _currency.code,
      );
    } catch (_) {
      _rateFromBase = 1.0;
    }
  }
}
