import 'dart:convert';
import 'package:http/http.dart' as http;

class GutenbergApi {
  final String baseUrl = 'https://gutendex.com/books/';

  Future<List<dynamic>> searchBooks(String query) async {
    final response = await http.get(Uri.parse('$baseUrl?search=${Uri.encodeComponent(query)}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'] ?? [];
    } else {
      throw Exception('Failed to load books');
    }
  }
}