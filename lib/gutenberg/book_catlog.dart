import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../homepage/isbn.dart';

class BookCatalogPage extends StatefulWidget {
  @override
  _BookCatalogPageState createState() => _BookCatalogPageState();
}

class _BookCatalogPageState extends State<BookCatalogPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _books = [];
  bool isLoading = false;
  bool hasError = false;
  String query = "";
  String selectedCategory = 'fiction';  // Default category to load

  @override
  void initState() {
    super.initState();
    fetchBooksByCategory(selectedCategory);  // Load books for the selected category
  }

  // Function to fetch books based on search query
  Future<void> searchBooks() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });
    final query = _searchController.text;
    if (query.isEmpty) {
      fetchBooksByCategory(selectedCategory);  // Load books for the default category
      return;
    }
    final url = 'https://www.googleapis.com/books/v1/volumes?q=$query';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final books = List<Map<String, dynamic>>.from(
          data['items']?.map((book) => book['volumeInfo']) ?? []);
      setState(() {
        _books = books;
        isLoading = false;
      });
    } else {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  // Function to fetch books by category
  Future<void> fetchBooksByCategory(String category) async {
    setState(() {
      isLoading = true;
      hasError = false;
    });
    final url = 'https://www.googleapis.com/books/v1/volumes?q=subject:$category';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final books = List<Map<String, dynamic>>.from(
          data['items']?.map((book) => book['volumeInfo']) ?? []);
      setState(() {
        _books = books;
        isLoading = false;
      });
    } else {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  // Category filter options
  final List<String> categories = [
    'fiction',
    'non-fiction',
    'mystery',
    'science',
    'biography',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Catalog'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              searchBooks();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                searchBooks();
              },
              decoration: InputDecoration(
                labelText: 'Search for books...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          // Category filter dropdown
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: DropdownButton<String>(
              value: selectedCategory,
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
                fetchBooksByCategory(value!);
              },
              items: categories
                  .map((category) => DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
            ),
          ),
          // Book grid view
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : hasError
                    ? Center(child: Text('Failed to load books'))
                    : GridView.builder(
                        padding: const EdgeInsets.all(8.0),
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemCount: _books.length,
                        itemBuilder: (context, index) {
                          final book = _books[index];
                          final title = book['title'];
                          final authors =
                              book['authors']?.join(', ') ?? 'Unknown';
                          final coverUrl =
                              book['imageLinks']?['thumbnail'] ?? '';

                          return GestureDetector(
                            onTap: () {
                              final isbn = book['industryIdentifiers']?[0]
                                      ['identifier'] ??
                                  'N/A';
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookDetailsPage(
                                    isbn: isbn,
                                    type: 'e-book',
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (coverUrl.isNotEmpty)
                                    Image.network(
                                      coverUrl,
                                      fit: BoxFit.cover,
                                      height: 180,
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      title,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      authors,
                                      style: GoogleFonts.poppins(fontSize: 14),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
