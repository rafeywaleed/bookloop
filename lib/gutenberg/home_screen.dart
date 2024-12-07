import 'package:bookloop/gutenberg/book_details_screen.dart';
import 'package:bookloop/gutenberg/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Gutenberg Catalog'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search for books',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    bookProvider.searchBooks(searchController.text);
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: bookProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: bookProvider.books.length,
                    itemBuilder: (context, index) {
                      final book = bookProvider.books[index];
                      return ListTile(
                        leading: Image.network(book.coverImageUrl),
                        title: Text(book.title),
                        subtitle: Text(book.authors.join(', ')),
                        trailing: IconButton(
                          icon: Icon(Icons.download),
                          onPressed: () async {
                            if (await canLaunch(book.downloadUrl)) {
                              await launch(book.downloadUrl);
                            } else {
                              throw 'Could not launch ${book.downloadUrl}';
                            }
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => BookDetailScreen(book: book)),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}