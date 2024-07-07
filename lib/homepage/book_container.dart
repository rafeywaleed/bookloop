// import 'package:bmi_calc/books.dart';
// import 'package:bmi_calc/isbn.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:percent_indicator/linear_percent_indicator.dart';

// class BookContainer extends StatelessWidget {
//   final Book book;

//   BookContainer({required this.book});

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;

//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           PageRouteBuilder(
//             transitionDuration: Duration(milliseconds: 700),
//             pageBuilder: (context, animation, secondaryAnimation) =>
//                 BookDetailsPage(
//               isbn: book.isbn,
//               type: book.type,
//             ),
//             transitionsBuilder:
//                 (context, animation, secondaryAnimation, child) {
//               var begin = Offset(0.0, 0.0);
//               var end = Offset.zero;
//               var curve = Curves.easeInOut;

//               var tween =
//                   Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

//               return ScaleTransition(
//                 scale: animation,
//                 child: child,
//               );
//             },
//           ),
//         );
//       },
//       child: Container(
//         width: size.width * 0.4,
//         decoration: BoxDecoration(
//           color: Color(0xFFEBCEA6),
//           boxShadow: const [
//             BoxShadow(
//               offset: Offset(4, 4),
//               blurRadius: 4,
//               spreadRadius: 0,
//               color: Colors.grey,
//             ),
//           ],
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               AnimatedSwitcher(
//                 duration: Duration(milliseconds: 500),
//                 child: Column(
//                   children: [
//                     Container(
//                       key: ValueKey<String>(book.isbn),
//                       height: 180,
//                       width: 120,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: FadeTransition(
//                         opacity: AlwaysStoppedAnimation(1.0),
//                         child: Image.network(
//                           book.imgUrl,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 10),
//               LinearPercentIndicator(
//                 barRadius: Radius.circular(20),
//                 width: size.width * 0.3,
//                 animation: true,
//                 lineHeight: 12.0,
//                 animationDuration: 2500,
//                 percent: 0.68,
//                 linearStrokeCap: LinearStrokeCap.roundAll,
//                 progressColor: Colors.black,
//               ),
//               SizedBox(height: 10),
//               Text(
//                 book.bookName,
//                 style: GoogleFonts.plusJakartaSans(
//                   textStyle: Theme.of(context).textTheme.bodyMedium,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               Text(
//                 book.author,
//                 style: GoogleFonts.plusJakartaSans(
//                   textStyle: Theme.of(context).textTheme.bodySmall,
//                   fontSize: 15,
//                   color: Color.fromARGB(255, 65, 65, 65),
//                   fontWeight: FontWeight.normal,
//                 ),
//               ),
//               Text(
//                 book.isbn,
//                 style: GoogleFonts.plusJakartaSans(
//                   textStyle: Theme.of(context).textTheme.bodySmall,
//                   fontSize: 15,
//                   color: Color.fromARGB(255, 65, 65, 65),
//                   fontWeight: FontWeight.normal,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
