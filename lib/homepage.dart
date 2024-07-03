import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '/isbn.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double angle = 0;
  int leftmostbook = 2;
  final List<double> snapAngles = [pi, pi / 2, 0, 3 * pi / 2];
  final List<Book> recentBooks = [
    Book(
      imgUrl:
          "https://m.media-amazon.com/images/I/71CKjYXMJrL._AC_UF1000,1000_QL80_.jpg",
      bookName: "The Kite Runner",
      author: "Khaled Hosseini",
      isbn: "9780747573395",
      type: 'print book',
    ),
    Book(
      imgUrl:
          "https://5.imimg.com/data5/SELLER/Default/2020/10/SI/BW/YL/43809805/screenshot-11-500x500.png",
      bookName: "The Alchemist",
      author: "Paulo Coelho",
      isbn: "9780008283643",
      type: 'e-book',
    ),
    Book(
      imgUrl:
          "https://m.media-amazon.com/images/I/81xIPfJ6iUL._AC_UF1000,1000_QL80_.jpg",
      bookName: "A Thousand Splendid Suns",
      author: "Khaled Hosseini",
      isbn: "9780747582977",
      type: 'e-book',
    ),
    Book(
      imgUrl:
          "https://m.media-amazon.com/images/I/71YXYFviUmL._AC_UF1000,1000_QL80_.jpg",
      bookName: "The Complete Novels of Sherlock Holmes",
      author: "Arthur Conan Doyle",
      isbn: "9789355201225",
      type: 'e-book',
    ),
  ];

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      angle -= details.delta.dy * 0.01;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      angle = _getSnappedAngle(angle);
      leftmostbook = _calculateLeftmostBookIndex(angle);
    });
  }

  int _calculateLeftmostBookIndex(double rotationAngle) {
    // Adjust the rotation angle to positive range (0 to 2π)
    if (rotationAngle < 0) {
      rotationAngle += 2 * pi;
    }

    // Calculate the leftmost angle in radians (π angle)
    double? leftmostAngle;

    // Calculate the angular distance between the current angle and each snap angle
    List<double> angularDistances = snapAngles.map((snapAngle) {
      double distance = (rotationAngle - snapAngle).abs();
      return distance;
    }).toList();

    // Find the index of the minimum angular distance
    int minIndex = angularDistances.indexOf(angularDistances
        .reduce((min, value) => min = min < value ? min : value));
    return minIndex;
  }

  double _getSnappedAngle(double currentAngle) {
    double closestAngle = snapAngles[0];
    double minDifference = (currentAngle - snapAngles[0]).abs();

    for (double snapAngle in snapAngles) {
      double difference = (currentAngle - snapAngle).abs();
      if (difference < minDifference) {
        minDifference = difference;
        closestAngle = snapAngle;
      }
    }

    return closestAngle;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Icon(Icons.book),
        title: Text("[AppName]"),
      ),
      backgroundColor: Color(0xFFE4D9D3),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello',
                style: GoogleFonts.plusJakartaSans(
                    textStyle: Theme.of(context).textTheme.displayLarge,
                    fontSize: 48,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF8D3F33)),
              ),
              Text(
                '     Rafey',
                style: GoogleFonts.plusJakartaSans(
                    textStyle: Theme.of(context).textTheme.displayLarge,
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF8D3F33)),
              ),
              SizedBox(height: 20),
              Text('Continue Reading', style: TextStyle(fontSize: 18)),
              SizedBox(height: 50),
              GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => BookDetailsPage(
                  //               isbn: recentBooks[leftbook_jugaad(leftmostbook)]
                  //                   .isbn,
                  //               type: recentBooks[leftbook_jugaad(leftmostbook)]
                  //                   .type,
                  //             )));
                  Navigator.push(
                      context,
                      PageTransition(
                          child: BookDetailsPage(
                              isbn: recentBooks[leftbook_jugaad(leftmostbook)]
                                  .isbn,
                              type: recentBooks[leftbook_jugaad(leftmostbook)]
                                  .type),
                          type: PageTransitionType.bottomToTop,
                          // alignment: Alignment.topLeft,
                          curve: Curves.easeIn,
                          duration: Durations.medium4));
                },
                child: Container(
                  width: size.width * 0.4,
                  decoration: BoxDecoration(
                    color: Color(0xFFEBCEA6),
                    boxShadow: const [
                      BoxShadow(
                          offset: Offset(4, 4),
                          blurRadius: 4,
                          spreadRadius: 0,
                          color: Colors.grey)
                    ],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedSwitcher(
                          duration: Duration(milliseconds: 500),
                          child: Column(
                            children: [
                              Container(
                                key: ValueKey<int>(leftmostbook),
                                height: 180,
                                width: 120,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20)),
                                child: FadeTransition(
                                  opacity: AlwaysStoppedAnimation(1.0),
                                  child: Image.network(
                                    recentBooks[leftbook_jugaad(leftmostbook)]
                                        .imgUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        LinearPercentIndicator(
                          barRadius: Radius.circular(20),
                          width: size.width * 0.3,
                          animation: true,
                          lineHeight: 12.0,
                          animationDuration: 2500,
                          percent: 0.68,
                          linearStrokeCap: LinearStrokeCap.roundAll,
                          progressColor: Colors.black,
                        ),
                        SizedBox(height: 10),
                        Text(
                          recentBooks[leftbook_jugaad(leftmostbook)].bookName,
                          style: GoogleFonts.plusJakartaSans(
                            textStyle: Theme.of(context).textTheme.bodyMedium,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          recentBooks[leftbook_jugaad(leftmostbook)].author,
                          style: GoogleFonts.plusJakartaSans(
                            textStyle: Theme.of(context).textTheme.bodySmall,
                            fontSize: 15,
                            color: Color.fromARGB(255, 65, 65, 65),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Text(
                          recentBooks[leftbook_jugaad(leftmostbook)].isbn,
                          style: GoogleFonts.plusJakartaSans(
                            textStyle: Theme.of(context).textTheme.bodySmall,
                            fontSize: 15,
                            color: Color.fromARGB(255, 65, 65, 65),
                            fontWeight: FontWeight.normal,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.1,
              ),
              Positioned(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: size.width * 0.2,
                          width: size.width * 0.2,
                          decoration: BoxDecoration(
                            color: Color(0xFFB64E3B),
                            boxShadow: const [
                              BoxShadow(
                                  offset: Offset(4, 4),
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                  color: Colors.grey)
                            ],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.menu_book_outlined,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Add a\nPrint Book",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.plusJakartaSans(
                              textStyle: Theme.of(context).textTheme.bodyMedium,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: size.width * 0.2,
                          width: size.width * 0.2,
                          decoration: BoxDecoration(
                            color: Color(0xFFB64E3B),
                            boxShadow: const [
                              BoxShadow(
                                  offset: Offset(4, 4),
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                  color: Colors.grey)
                            ],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.phonelink,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Add an\nE-Book",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.plusJakartaSans(
                              textStyle: Theme.of(context).textTheme.bodyMedium,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: size.width * 0.2,
                          width: size.width * 0.2,
                          decoration: BoxDecoration(
                            color: Color(0xFFB64E3B),
                            boxShadow: const [
                              BoxShadow(
                                  offset: Offset(4, 4),
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                  color: Colors.grey)
                            ],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.cruelty_free_outlined,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Invite a\nFriend",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.plusJakartaSans(
                              textStyle: Theme.of(context).textTheme.bodyMedium,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      //     BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Community'),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      //   ],
      // ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color(0xFF445C74),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GNav(
                backgroundColor: Color(0xFF445C74),
                curve: Curves.easeOutExpo,
                duration: Duration(milliseconds: 400),
                gap: 8,
                color: Colors.white,
                iconSize: 30,
                tabBackgroundColor: Color.fromARGB(95, 230, 230, 230),
                activeColor: Colors.white,
                padding: EdgeInsets.all(15),
                tabs: const [
                  GButton(
                    icon: Icons.home,
                    text: 'Home',
                  ),
                  GButton(
                    icon: Icons.menu_book_sharp,
                    text: 'Books',
                  ),
                  GButton(
                    icon: Icons.people_alt_outlined,
                    text: 'Social',
                  ),
                  GButton(
                    icon: Icons.person_pin,
                    text: 'Profile',
                  )
                ]),
          ),
        ),
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            right: -130,
            top: size.height * 0.3,
            child: GestureDetector(
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 320,
                      height: 320,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFC38560).withOpacity(0.8),
                          boxShadow: const [
                            BoxShadow(
                                offset: Offset(0, 4),
                                blurRadius: 4,
                                spreadRadius: 0,
                                color: Colors.grey)
                          ]),
                      child: Transform.rotate(
                        angle: angle,
                        child: AnimatedSwitcher(
                          duration: Duration(milliseconds: 500),
                          child: Stack(
                            alignment: Alignment.center,
                            children: recentBooks.asMap().entries.map((entry) {
                              int index = entry.key;
                              Book book = entry.value;
                              String isbn = entry.value.isbn;

                              return MenuTile(
                                snapAngles[index],
                                angle,
                                book,
                                isbn,
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFE4D9D3),
                      ),
                      child: Center(
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF8A4A3E),
                              boxShadow: const [
                                BoxShadow(
                                    offset: Offset(0, 4),
                                    blurRadius: 4,
                                    spreadRadius: 0,
                                    color: Colors.grey)
                              ]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Book {
  final String imgUrl;
  final String bookName;
  final String author;
  final String isbn;
  final String type;

  Book(
      {required this.imgUrl,
      required this.bookName,
      required this.author,
      required this.isbn,
      required this.type});
}

Widget MenuTile(
    double positionAngle, double rotationAngle, Book book, String isbn) {
  return Transform(
    transform: Matrix4.identity()
      ..translate(100.0 * cos(positionAngle), 100.0 * sin(positionAngle)),
    child: Transform.rotate(
      angle: -rotationAngle,
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 80,
              width: 50,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: FadeTransition(
                opacity: AlwaysStoppedAnimation(1.0),
                child: Image(
                  image: NetworkImage(
                    book.imgUrl,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // LinearPercentIndicator(
            //   barRadius: Radius.circular(20),
            //   width: 80.0,
            //   lineHeight: 8.0,
            //   percent: 0.43,
            //   progressColor: Colors.black,
            // )
          ],
        ),
      ),
    ),
  );
}

int leftbook_jugaad(int leftmostbook) {
  if (leftmostbook == 0)
    return 2;
  else if (leftmostbook == 2)
    return 0;
  else
    return leftmostbook;
}
