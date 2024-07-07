
// import 'dart:math';

// import 'package:bookloop/homepage.dart';
// import 'package:flutter/material.dart';

// class CirMenu extends StatefulWidget {
//   const CirMenu({super.key});

//   @override
//   State<CirMenu> createState() => _CirMenuState();
// }

// class _CirMenuState extends State<CirMenu> {

//   double angle = 0;
//   int leftmostbook = 2;
//   final List<double> snapAngles = [pi, pi / 2, 0, 3 * pi / 2];
//   double _getSnappedAngle(double currentAngle) {
//     double closestAngle = snapAngles[0];
//     double minDifference = (currentAngle - snapAngles[0]).abs();

//     for (double snapAngle in snapAngles) {
//       double difference = (currentAngle - snapAngle).abs();
//       if (difference < minDifference) {
//         minDifference = difference;
//         closestAngle = snapAngle;
//       }
//     }

//     return closestAngle;
//   }
//  void _onPanUpdate(DragUpdateDetails details) {
//     setState(() {
//       angle -= details.delta.dy * 0.01;
//     });
//   }

//   void _onPanEnd(DragEndDetails details) {
//     setState(() {
//       angle = _getSnappedAngle(angle);
//       leftmostbook = _calculateLeftmostBookIndex(angle);
//     });
//   }
  
//   int _calculateLeftmostBookIndex(double rotationAngle) {
//     // Adjust the rotation angle to positive range (0 to 2π)
//     if (rotationAngle < 0) {
//       rotationAngle += 2 * pi;
//     }

//     // Calculate the leftmost angle in radians (π angle)
//     double? leftmostAngle;

//     // Calculate the angular distance between the current angle and each snap angle
//     List<double> angularDistances = snapAngles.map((snapAngle) {
//       double distance = (rotationAngle - snapAngle).abs();
//       return distance;
//     }).toList();

//     // Find the index of the minimum angular distance
//     int minIndex = angularDistances.indexOf(angularDistances
//         .reduce((min, value) => min = min < value ? min : value));
//     return minIndex;
//   }

//    Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     return Stack(
//         children: [
//           Positioned(
//             right: -130,
//             top: size.height * 0.4,
//             child: GestureDetector(
//               onPanUpdate: _onPanUpdate,
//               onPanEnd: _onPanEnd,
//               child: Center(
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     Container(
//                       width: size.width * 0.75,
//                       height: size.width * 0.75,
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Color(0xFFC38560).withOpacity(0.8),
//                           boxShadow: const [
//                             BoxShadow(
//                                 offset: Offset(0, 4),
//                                 blurRadius: 4,
//                                 spreadRadius: 0,
//                                 color: Colors.grey)
//                           ]),
//                       child: Transform.rotate(
//                         angle: angle,
//                         child: AnimatedSwitcher(
//                           duration: Duration(milliseconds: 500),
//                           child: Stack(
//                             alignment: Alignment.center,
//                             children: recentBooks.asMap().entries.map((entry) {
//                               int index = entry.key;
//                               Book book = entry.value;
//                               String isbn = entry.value.isbn;

//                               return MenuTile(
//                                 snapAngles[index],
//                                 angle,
//                                 book,
//                                 isbn,
//                               );
//                             }).toList(),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Container(
//                       height: 100,
//                       width: 100,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Color(0xFFE4D9D3),
//                       ),
//                       child: Center(
//                         child: Container(
//                           width: 40,
//                           height: 40,
//                           decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Color(0xFF8A4A3E),
//                               boxShadow: const [
//                                 BoxShadow(
//                                     offset: Offset(0, 4),
//                                     blurRadius: 4,
//                                     spreadRadius: 0,
//                                     color: Colors.grey)
//                               ]),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       );
//   }
// }


// Widget MenuTile(
//     double positionAngle, double rotationAngle, Book book, String isbn) {
//   return Transform(
//     transform: Matrix4.identity()
//       ..translate(100.0 * cos(positionAngle), 100.0 * sin(positionAngle)),
//     child: Transform.rotate(
//       angle: -rotationAngle,
//       child: Container(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               height: 80,
//               width: 50,
//               decoration:
//                   BoxDecoration(borderRadius: BorderRadius.circular(20)),
//               child: FadeTransition(
//                 opacity: AlwaysStoppedAnimation(1.0),
//                 child: Image(
//                   image: NetworkImage(
//                     book.imgUrl,
//                   ),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }

// int leftbook_jugaad(int leftmostbook) {
//   if (leftmostbook == 0)
//     return 2;
//   else if (leftmostbook == 2)
//     return 0;
//   else
//     return leftmostbook;
// }

















