import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bookloop/gutenberg/book.dart';
import 'package:bookloop/gutenberg/gutenberg_api.dart';
import 'package:flutter/material.dart';

class BookProvider with ChangeNotifier {
  List<Book> _books = [];
  bool _isLoading = false;

  List<Book> get books => _books;
  bool get isLoading => _isLoading;

  Future<void> searchBooks(String query) async {
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse('https://gutendex.com/books/?search=$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<dynamic> booksJson = jsonData['results'];

      // Ensure you correctly cast the dynamic list to List<Book>
      _books = booksJson.map<Book>((bookJson) => Book.fromJson(bookJson)).toList();
    } else {
      print('Failed to load books');
    }

    _isLoading = false;
    notifyListeners();
  }
}