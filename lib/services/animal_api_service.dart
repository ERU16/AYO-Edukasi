import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/animal.dart';

class ApiService {
  static const String _baseUrl = 'https://api.api-ninjas.com/v1';
  static const String _apiKey =
      'PZ4VBVKuLqiewoe8m2ESrQ==beFmPNp5mlUF9Fio'; // Ganti dengan API key Anda!

  static Future<List<Animal>> fetchCats(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/cats?name=$query'),
        headers: {'X-Api-Key': _apiKey},
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Animal.fromJson(json)).toList();
      } else {
        throw Exception('Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to fetch cats: $e');
    }
  }
}
