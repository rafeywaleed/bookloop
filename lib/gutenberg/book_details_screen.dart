import 'package:bookloop/gutenberg/book.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BookDetailScreen extends StatelessWidget { final Book book;

BookDetailScreen({required this.book});

@override Widget build(BuildContext context) { 
  return Scaffold( 
    appBar: AppBar( title: Text(book.title), ), 
    body: Padding( padding: const EdgeInsets.all(16.0), child: Column( children: [ if (book.coverImageUrl.isNotEmpty) Image.network(book.coverImageUrl), SizedBox(height: 16), Text(book.title, style: TextStyle(fontSize: 24)), SizedBox(height: 8), Text(book.authors.join(', ')), SizedBox(height: 16), ElevatedButton( onPressed: () async { if (book.downloadUrl.isNotEmpty && await canLaunch(book.downloadUrl)) { await launch(book.downloadUrl); } else { // Handle the error or show a message 
print('Invalid download URL: ${book.downloadUrl}'); } }, child: Text('Download'), ), ], ), ), ); } }