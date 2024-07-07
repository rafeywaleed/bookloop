import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/linear_percent_indicator.dart';

class BookDetailsPage extends StatefulWidget {
  final String isbn;
  final String type;

  BookDetailsPage({required this.isbn, required this.type});

  @override
  _BookDetailsPageState createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  Map<String, dynamic> bookDetails = {};
  bool isLoading = true;
  bool hasError = false;

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
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } else {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      // floatingActionButton: widget.type == "e-book"
      //     ? FloatingActionButton(
      //         onPressed: () {},
      //         backgroundColor: Color(0xFF445C74),
      //         child: Padding(
      //           padding: const EdgeInsets.only(left: 5, right: 5),
      //           child: Text(
      //             "Read",
      //             style: GoogleFonts.poppins(
      //               textStyle: Theme.of(context).textTheme.bodySmall,
      //               fontSize: 16,
      //               color: Colors.white,
      //               fontWeight: FontWeight.normal,
      //             ),
      //           ),
      //         ),
      //       )
      //  : null,
      body: Stack(
        children: [
          if (isLoading)
            Center(child: CircularProgressIndicator())
          else if (hasError)
            Center(child: Text("Failed to load book details"))
          else
            Container(
              width: size.width,
              height: size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(bookDetails['coverUrl']),
                  fit: BoxFit.cover,
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(top: size.height * 0.1 + 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16),
                          Text(
                            bookDetails['title'],
                            style: GoogleFonts.plusJakartaSans(
                              textStyle: Theme.of(context).textTheme.bodyLarge,
                              fontSize: 30,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Author: ${bookDetails['authors']}',
                            style: GoogleFonts.poppins(
                              textStyle:
                                  Theme.of(context).textTheme.labelMedium,
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Genre: ${bookDetails['genre']}',
                            style: GoogleFonts.poppins(
                              textStyle: Theme.of(context).textTheme.bodyLarge,
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          SizedBox(height: 16),
                          Image.network(bookDetails['coverUrl']),
                          SizedBox(height: 16),
                          Text(
                            bookDetails['description'],
                            style: GoogleFonts.poppins(
                              textStyle: Theme.of(context).textTheme.bodyLarge,
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Average Rating: ${bookDetails['averageRating']}',
                            style: GoogleFonts.poppins(
                              textStyle: Theme.of(context).textTheme.bodyLarge,
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Ratings Count: ${bookDetails['ratingsCount']}',
                            style: GoogleFonts.poppins(
                              textStyle: Theme.of(context).textTheme.bodyLarge,
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Publisher: ${bookDetails['publisher']}',
                            style: GoogleFonts.poppins(
                              textStyle: Theme.of(context).textTheme.bodyLarge,
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Published Date: ${bookDetails['publishedDate']}',
                            style: GoogleFonts.poppins(
                              textStyle: Theme.of(context).textTheme.bodyLarge,
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            top: 40,
            left: 10,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.5),
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
          widget.type == "e-book"
              ? Positioned(
                  bottom: 30,
                  right: 15,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xFF445C74),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        "Read",
                        style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.bodySmall,
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ))
              : Container(),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: LinearPercentIndicator(
                    //barRadius: Radius.circular(20),
                    width: size.width,
                    animation: true,
                    lineHeight: 12.0,
                    animationDuration: 2500,
                    percent: 0.68,
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    progressColor: Colors.black,
                  ),
                ),
        ],
      ),
    );
  }
}
