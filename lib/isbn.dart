import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class BookDetailsPage extends StatefulWidget {
  final String isbn;
  final String type;

  BookDetailsPage({required this.isbn, required this.type});
  @override
  _BookDetailsPageState createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  Map<String, dynamic> bookDetails = {};

  @override
  void initState() {
    super.initState();
    fetchBookDetails(widget.isbn); 
  }

  Future<void> fetchBookDetails(String isbn) async {
    final url = 'https://www.googleapis.com/books/v1/volumes?q=isbn:$isbn';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final items = data['items'];
      if (items != null && items.isNotEmpty) {
        final volumeInfo = items[0]['volumeInfo'];
        setState(() {
          bookDetails = {
            'title': volumeInfo['title'],
            'authors': volumeInfo['authors'].join(', '),
            'genre': volumeInfo['categories']?.join(', ') ?? 'N/A',
            'coverUrl': volumeInfo['imageLinks']['thumbnail'],
            'description': volumeInfo['description'] ?? 'N/A',
            'averageRating': volumeInfo['averageRating']?.toString() ?? 'N/A',
            'ratingsCount': volumeInfo['ratingsCount']?.toString() ?? 'N/A',
            'publisher': volumeInfo['publisher'] ?? 'N/A',
            'publishedDate': volumeInfo['publishedDate'] ?? 'N/A',
          };
        });
      }
    } else {
      throw Exception('Failed to load book details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: widget.type == "e-book"
          ? FloatingActionButton(
              onPressed: () {},
              child: Text("Read"),
            )
          : null,
      body: bookDetails.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(),
                  Text('Title: ${bookDetails['title']}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Spacer(),
                  Text('Authors: ${bookDetails['authors']}',
                      style: TextStyle(fontSize: 16)),
                  Spacer(),
                  Text('Genre: ${bookDetails['genre']}',
                      style: TextStyle(fontSize: 16)),
                  Spacer(),
                  Image.network(bookDetails['coverUrl']),
                  Spacer(),
                  Text('Description: \n${bookDetails['description']}',
                      style: TextStyle(fontSize: 14)),
                  Spacer(),
                  Text('Average Rating: ${bookDetails['averageRating']}',
                      style: TextStyle(fontSize: 14)),
                  Text('Ratings Count: ${bookDetails['ratingsCount']}',
                      style: TextStyle(fontSize: 14)),
                  Text('Publisher: ${bookDetails['publisher']}',
                      style: TextStyle(fontSize: 14)),
                  Text('Published Date: ${bookDetails['publishedDate']}',
                      style: TextStyle(fontSize: 14)),
                ],
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
