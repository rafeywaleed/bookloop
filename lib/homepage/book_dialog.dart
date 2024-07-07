import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class BookDialog extends StatefulWidget {
  final Image cover;
  final String title;
  final String author;
  final String isbn;
  final String type;

  const BookDialog({
    required this.cover,
    required this.title,
    required this.author,
    required this.isbn,
    required this.type,
    Key? key,
  }) : super(key: key);

  @override
  State<BookDialog> createState() => _BookDialogState();
}

class _BookDialogState extends State<BookDialog> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Dialog(
      child: Container(
        height: size.height * 0.6,
        width: size.width * 0.8,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  spreadRadius: 5,
                  blurRadius: 10,
                  color: Color.fromARGB(255, 43, 43, 43))
            ]),
       // padding: EdgeInsets.all(20),
        child: Stack(children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: size.height * 0.3,
                      width: size.width * 0.5,
                      // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                      child: widget.cover,
                    ),
                  ),
                  SizedBox(height: 10),
              
                  SizedBox(height: 10),
                  Text(
                    widget.title,
                    style: GoogleFonts.plusJakartaSans(
                      textStyle: Theme.of(context).textTheme.bodyLarge,
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "author: ${widget.author}",
                    style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.labelMedium,
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
              
                  Text(
                    "type: ${widget.type}",
                    style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.labelMedium,
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 20),
                  // ElevatedButton(
                  //   onPressed: () {
                  //   },
                  //   child: Text('Read'),
                  // ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            right: 30,
            child: widget.type == "e-book"
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color(0xFF445C74),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "Read",
                        style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.bodySmall,
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  )
                : Container(),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: LinearPercentIndicator(
              //barRadius: Radius.circular(20),
              width: size.width * 0.75,
              animation: true,
              lineHeight: 12.0,
              animationDuration: 2500,
              percent: 0.68,
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: Colors.black,
            ),
          ),
        ]),
      ),
    );
  }
}
