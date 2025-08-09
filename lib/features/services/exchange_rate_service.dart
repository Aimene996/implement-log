import 'dart:convert';

import 'package:http/http.dart' as http;

class ExchangeRateService {
  // Primary: Frankfurter public API: https://www.frankfurter.app
  static const String _frankfurterUrl = 'https://api.frankfurter.app/latest';
  // Secondary fallback: exchangerate.host
  static const String _hostUrl = 'https://api.exchangerate.host/latest';

  static final Map<String, double> _memoryCache = <String, double>{};

  // Conservative static fallback rates relative to USD for offline/failed API
  static const Map<String, double> _fallbackFromUSD = <String, double>{
    'USD': 1.0,
    'EUR': 0.92,
    'JPY': 155.0,
    'GBP': 0.78,
    'AUD': 1.49,
    'CAD': 1.36,
    'CHF': 0.90,
    'CNY': 7.26,
    'HKD': 7.81,
    'RUB': 89.0,
  };

  static Future<double> fetchRate({
    required String from,
    required String to,
  }) async {
    if (from == to) return 1.0;

    final cacheKey = '$from->$to';
    final cached = _memoryCache[cacheKey];
    if (cached != null) return cached;

    // Try Frankfurter first
    final frankfurter = await _fetchFromFrankfurter(from: from, to: to);
    if (frankfurter != null) {
      _memoryCache[cacheKey] = frankfurter;
      return frankfurter;
    }

    // Fallback to exchangerate.host
    final host = await _fetchFromHost(from: from, to: to);
    if (host != null) {
      _memoryCache[cacheKey] = host;
      return host;
    }

    // Final fallback
    // Use static fallbacks for major currencies
    if (from == 'USD') {
      return _fallbackFromUSD[to] ?? 1.0;
    }
    if (to == 'USD') {
      final fromRate = _fallbackFromUSD[from];
      if (fromRate != null && fromRate != 0) return 1.0 / fromRate;
      return 1.0;
    }
    // Cross via USD if both present
    final fromRate = _fallbackFromUSD[from];
    final toRate = _fallbackFromUSD[to];
    if (fromRate != null && toRate != null && fromRate != 0) {
      return toRate / fromRate;
    }
    return 1.0;
  }

  static Future<double?> _fetchFromFrankfurter({
    required String from,
    required String to,
  }) async {
    try {
      final uri = Uri.parse('$_frankfurterUrl?from=$from&to=$to');
      final response = await http.get(uri).timeout(const Duration(seconds: 8));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(response.body) as Map<String, dynamic>;
        final rates = (data['rates'] as Map).cast<String, dynamic>();
        final dynamic raw = rates[to];
        if (raw is num) return raw.toDouble();
      }
    } catch (_) {}
    return null;
  }

  static Future<double?> _fetchFromHost({
    required String from,
    required String to,
  }) async {
    try {
      final uri = Uri.parse('$_hostUrl?base=$from&symbols=$to');
      final response = await http.get(uri).timeout(const Duration(seconds: 8));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(response.body) as Map<String, dynamic>;
        final rates = (data['rates'] as Map).cast<String, dynamic>();
        final dynamic raw = rates[to];
        if (raw is num) return raw.toDouble();
      }
    } catch (_) {}
    return null;
  }
}
