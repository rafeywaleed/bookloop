import 'package:bookloop/homepage.dart';
import 'package:bookloop/homepage/book_dialog.dart';
import 'package:bookloop/homepage/library.dart';
import 'package:bookloop/homepageIndex.dart';
import 'package:bookloop/profile.dart';
import 'package:bookloop/social.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'homepage/isbn.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  double angle = 0;
  int leftmostbook = 2;
  int pageIndex = 0;

  final pages = [
    const HomePageIndex(),
    const Library(),
    const Social(),
    const Profile(),
  ];

  final List<double> snapAngles = [pi, pi / 2, 0, 3 * pi / 2];
  final List<Book> recentBooks = [
    Book(
      imgUrl:
          "https://m.media-amazon.com/images/I/71CKjYXMJrL._AC_UF1000,1000_QL80_.jpg",
      bookName: "The Kite Runner",
      author: "Khaled Hosseini",
      isbn: "9780747573395",
      type: 'e-book',
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
      type: 'print book',
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

  late AnimationController _animationController;
  late Animation<double> _animation;

  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutExpo,
    );
  }

  void onTabTapped(int index) {
    setState(() {
      pageIndex = index;
    });
    _animationController.forward(from: 0.0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   leading: Icon(Icons.book),
      //   title: Text("[AppName]"),
      // ),
      backgroundColor: Color(0xFFE4D9D3),
      // floatingActionButton: Stack(children: [
      //   Positioned(
      //     right: -130,
      //     top: size.height * 0.3,
      //     child: GestureDetector(
      //       onPanUpdate: _onPanUpdate,
      //       onPanEnd: _onPanEnd,
      //       child: Center(
      //         child: Stack(
      //           alignment: Alignment.center,
      //           children: [
      //             Container(
      //               width: size.width * 0.75,
      //               height: size.width * 0.75,
      //               alignment: Alignment.center,
      //               decoration: BoxDecoration(
      //                   shape: BoxShape.circle,
      //                   color: Color(0xFFC38560).withOpacity(0.8),
      //                   boxShadow: const [
      //                     BoxShadow(
      //                         offset: Offset(0, 4),
      //                         blurRadius: 4,
      //                         spreadRadius: 0,
      //                         color: Colors.grey)
      //                   ]),
      //               child: Transform.rotate(
      //                 angle: angle,
      //                 child: AnimatedSwitcher(
      //                   duration: Duration(milliseconds: 500),
      //                   child: Stack(
      //                     alignment: Alignment.center,
      //                     children: recentBooks.asMap().entries.map((entry) {
      //                       int index = entry.key;
      //                       Book book = entry.value;
      //                       String isbn = entry.value.isbn;

      //                       return MenuTile(
      //                         snapAngles[index],
      //                         angle,
      //                         book,
      //                         isbn,
      //                       );
      //                     }).toList(),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //             Container(
      //               height: 100,
      //               width: 100,
      //               decoration: BoxDecoration(
      //                 shape: BoxShape.circle,
      //                 color: Color(0xFFE4D9D3),
      //               ),
      //               child: Center(
      //                 child: Container(
      //                   width: 40,
      //                   height: 40,
      //                   decoration: BoxDecoration(
      //                       shape: BoxShape.circle,
      //                       color: Color(0xFF8A4A3E),
      //                       boxShadow: const [
      //                         BoxShadow(
      //                             offset: Offset(0, 4),
      //                             blurRadius: 4,
      //                             spreadRadius: 0,
      //                             color: Colors.grey)
      //                       ]),
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
      // ]),
      body: pages[pageIndex],
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color(0xFF445C74),
          ),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildNavItem(Icons.home, 'Home', 0),
                buildNavItem(Icons.menu_book_sharp, 'Books', 1),
                buildNavItem(Icons.people_alt_outlined, 'Social', 2),
                buildNavItem(Icons.person_pin, 'Profile', 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildNavItem(IconData icon, String text, int index) {
    bool isSelected = pageIndex == index;

    return GestureDetector(
      onTap: () => onTabTapped(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        curve: Curves.easeOutExpo,
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: isSelected
              ? Color.fromARGB(95, 230, 230, 230)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Colors.white
                  : Color.fromARGB(255, 216, 216, 216),
              size: 30,
            ),
            SizedBox(width: 8),
            if (isSelected)
              Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
          ],
        ),
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
