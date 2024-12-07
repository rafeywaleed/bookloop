// import 'package:flutter/material.dart';
// import 'package:epubx/epubx.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:shader_presets/shader_presets.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:file_picker/file_picker.dart';
// import 'dart:io';

// class EpubHomePage extends StatefulWidget {
//   @override
//   _EpubHomePageState createState() => _EpubHomePageState();
// }

// class _EpubHomePageState extends State<EpubHomePage> {
//   String? epubPath;
//   EpubBook? book;
//   int currentPageIndex = 0;
//   List<String> pages = [];
//   final ShaderPresetController presetController = ShaderPresetController();
//   double fontSize = 16.0;
//   String fontFamily = 'Arial';
//   List<int> bookmarks = [];
//   bool isDarkTheme = false;

//   @override
//   void initState() {
//     super.initState();
//     loadPreferences();
//   }

//   Future<void> loadPreferences() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       fontSize = prefs.getDouble('fontSize') ?? 16.0;
//       fontFamily = prefs.getString('fontFamily') ?? 'Arial';
//       bookmarks = prefs.getStringList('bookmarks')?.map((e) => int.parse(e)).toList() ?? [];
//       isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
//     });
//   }

//   Future<void> savePreferences() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setDouble('fontSize', fontSize);
//     prefs.setString('fontFamily', fontFamily);
//     prefs.setStringList('bookmarks', bookmarks.map((e) => e.toString()).toList());
//     prefs.setBool('isDarkTheme', isDarkTheme);
//   }

//   Future<void> openEpub() async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['epub'],
//     );

//     if (result != null) {
//       setState(() {
//         epubPath = result.files.single.path;
//       });

//       final file = File(epubPath!);
//       book = await EpubReader.readBook(file.readAsBytesSync());

//       // Extract pages
//       pages = book!.getContents().map((content) => content.HtmlContent).toList();
//       setState(() {});
//     }
//   }

//   void nextPage() {
//     if (currentPageIndex < pages.length - 1) {
//       setState(() {
//         currentPageIndex++;
//       });
//       animatePageCurl();
//     }
//   }

//   void previousPage() {
//     if (currentPageIndex > 0) {
//       setState(() {
//         currentPageIndex--;
//       });
//       animatePageCurl();
//     }
//   }

//   void animatePageCurl() {
//     presetController.getShaderController()!.animateUniform(
//       uniformName: 'progress',
//       begin: 0,
//       end: 1,
//       duration: const Duration(milliseconds: 600),
//       curve: Curves.decelerate,
//     );
//   }

//   void toggleBookmark() {
//     setState (() {
//       if (bookmarks.contains(currentPageIndex)) {
//         bookmarks.remove(currentPageIndex);
//       } else {
//         bookmarks.add(currentPageIndex);
//       }
//       savePreferences();
//     });
//   }

//   void changeFontSize(double newSize) {
//     setState(() {
//       fontSize = newSize;
//     });
//     savePreferences();
//   }

//   void changeFontFamily(String newFamily) {
//     setState(() {
//       fontFamily = newFamily;
//     });
//     savePreferences();
//   }

//   void toggleTheme() {
//     setState(() {
//       isDarkTheme = !isDarkTheme;
//     });
//     savePreferences();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('EPUB Reader'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.open_book),
//             onPressed: openEpub,
//           ),
//           IconButton(
//             icon: Icon(bookmarks.contains(currentPageIndex) ? Icons.bookmark : Icons.bookmark_border),
//             onPressed: toggleBookmark,
//           ),
//           IconButton(
//             icon: Icon(Icons.text_fields),
//             onPressed: () {
//               showDialog(
//                 context: context,
//                 builder: (context) => AlertDialog(
//                   title: Text('Font Settings'),
//                   content: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Slider(
//                         value: fontSize,
//                         min: 12.0,
//                         max: 24.0,
//                         onChanged: changeFontSize,
//                       ),
//                       DropdownButton<String>(
//                         value: fontFamily,
//                         onChanged: changeFontFamily,
//                         items: [
//                           DropdownMenuItem(child: Text('Arial'), value: 'Arial'),
//                           DropdownMenuItem(child: Text('Times New Roman'), value: 'Times New Roman'),
//                           DropdownMenuItem(child: Text('Courier'), value: 'Courier'),
//                         ],
//                       ),
//                     ],
//                   ),
//                   actions: [
//                     ElevatedButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       child: Text('Save'),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//           IconButton(
//             icon: Icon(isDarkTheme ? Icons.light_mode : Icons.dark_mode),
//             onPressed: toggleTheme,
//           ),
//         ],
//       ),
//       body: epubPath == null
//           ? Center(child: Text('No EPUB file selected'))
//           : ShaderPresetPageCurl(
//               child1: Html(
//                 data: pages[currentPageIndex],
//                 style: {
//                   'body': Style(
//                     fontSize: FontSize(fontSize),
//                     fontFamily: fontFamily,
//                   ),
//                 },
//               ),
//               child2: currentPageIndex < pages.length - 1
//                   ? Html(
//                       data: pages[currentPageIndex + 1],
//                       style: {
//                         'body': Style(
//                           fontSize: FontSize(fontSize),
//                           fontFamily: fontFamily,
//                         ),
//                       },
//                     )
//                   : Container(), // Handle the last page case
//               presetController: presetController,
//               radius: 1.0,
//             ),
//       floatingActionButton: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           FloatingActionButton(
//             onPressed: previousPage,
//             child: Icon(Icons.arrow_back),
//           ),
//           FloatingActionButton(
//             onPressed: nextPage,
//             child: Icon(Icons.arrow_forward),
//           ),
//         ],
//       ),
//       theme: isDarkTheme ? ThemeData.dark() : ThemeData.light(),
//     );
//   }
// }