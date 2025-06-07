import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import '../models/currency.dart';

class CurrencyService {
  static const String _url = 'https://api.frankfurter.dev/v1/latest';

  // Fungsi untuk mendapatkan nilai tukar mata uang real-time
  static Future<double?> getExchangeRate(String fromCurrency, String toCurrency) async {
    final response = await http.get(
      Uri.parse('$_url?from=$fromCurrency&to=$toCurrency'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Mengambil nilai tukar mata uang
      return (data['rates'][toCurrency] as num?)?.toDouble();
    } else {
      throw Exception('Failed to load exchange rates');
    }
  }

  // Fungsi untuk mengonversi jumlah mata uang berdasarkan nilai tukar
  static Future<CurrencyConverter> convertCurrency(
    CurrencyConverter converter,
  ) async {
    try {
      final rate = await getExchangeRate(converter.fromCurrency, converter.toCurrency);
      if (rate != null) {
        final convertedAmount = converter.amount * rate;
        converter.setConvertedAmount(convertedAmount);
      }
      return converter;
    } catch (e) {
      throw Exception('Error converting currency: $e');
    }
  }
}
