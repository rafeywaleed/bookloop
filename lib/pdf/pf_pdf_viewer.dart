// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// import 'package:page_turn/page_turn.dart';

// class PdfViewerPage extends StatefulWidget {
//   final String filePath;

//   PdfViewerPage({required this.filePath});

//   @override
//   _PdfViewerPageState createState() => _PdfViewerPageState();
// }

// class _PdfViewerPageState extends State<PdfViewerPage> {
//   PdfViewerController _pdfViewerController = PdfViewerController();
//   final GlobalKey<SearchToolbarState> _textSearchKey = GlobalKey();
//   bool _showToolbar = false;
//   bool _showScrollHead = true;
//   final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
//   LocalHistoryEntry? _historyEntry;

//   int _currentPage = 0;
//   int _totalPages = 0;
//   bool _isHorizontalScroll = false;
//   List<Bookmark> _bookmarks = [];
//   bool _isFullScreen = false;
//   late PdfTextSearchResult _searchResult;
//   late List<Widget> _pages;

//   @override
//   void initState() {
//     super.initState();
//     _loadPdf();
//     _searchResult = PdfTextSearchResult();
//   }

//   Future<void> _loadPdf() async {
//     _pdfViewerController = PdfViewerController();
//     _totalPages = await _pdfViewerController.pageCount;
//     _pages = List.generate(_totalPages, (index) {
//       return SfPdfViewer.file(
//         File(widget.filePath),
//         controller: _pdfViewerController,
//         pageLayoutMode: PdfPageLayoutMode.single,
//         onPageChanged: (PdfPageChangedDetails details) {
//           setState(() {
//             _currentPage = details.newPageNumber - 1; // Adjust for 0-based index
//           });
//         },
//       );
//     });
//     setState(() {});
//   }

//   void _addBookmark() {
//     final bookmark = Bookmark(text: 'Bookmark ${_bookmarks.length + 1}', page: _currentPage + 1);
//     setState(() {
//       _bookmarks.add(bookmark);
//     });
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Bookmark added')));
//   }

//   void _viewBookmarks() {
//     if (_bookmarks.isNotEmpty) {
//       _pdfViewerController.jumpToPage(_bookmarks.last.page);
//     }
//   }

//   void _toggleToolbar() {
//     setState(() {
//       _showToolbar = !_showToolbar;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       child: Scaffold(
//         appBar: _isFullScreen
//             ? null
//             : AppBar(
//                 title: Text('PDF Viewer'),
//                 actions: [
//                   IconButton(
//                     icon: Icon(Icons.bookmark),
//                     onPressed: _addBookmark,
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.list),
//                     onPressed: _viewBookmarks,
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.search),
//                     onPressed: _toggleToolbar,
//                   ),
//                 ],
//               ),
//         body: _pages.isEmpty
//             ? Center(child: CircularProgressIndicator())
//             : PageTurn(
//                 children: _pages,
//                 showDragCurl: true,
//                 curlShadow: true,
//                 animationDuration: 500,
//                 onSlideUpdate: (value) {
//                   if (value < 0.5 && _currentPage > 0) {
//                     setState(() {
//                       _currentPage--;
//                     });
//                   } else if (value >= 0.5 && _currentPage < _pages.length - 1) {
//                     setState(() {
//                       _currentPage++;
//                     });
//                   }
//                 },
//               ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: _toggleToolbar,
//           child: Icon(_showToolbar ? Icons.close : Icons.menu),
//         ),
//       ),
//     );
//   }
// }

// class Bookmark {
//   String text;
//   int page;

//   Bookmark({required this.text, required this.page});
// }

// /// Signature for the [SearchToolbar.onTap] callback.
// typedef SearchTapCallback = void Function(Object item);

// /// SearchToolbar widget
// class SearchToolbar extends StatefulWidget {
//   const SearchToolbar({
//     this.controller,
//     this.onTap,
//     this.showTooltip = true,
//     super.key,
//   });

//   final bool showTooltip;
//   final PdfViewerController? controller;
//   final SearchTapCallback? onTap;

//   @override
//   SearchToolbarState createState() => SearchToolbarState();
// }

// class SearchToolbarState extends State<SearchToolbar> {
//   bool _isSearchInitiated = false;
//   bool _showToast = false;
//   final TextEditingController _editingController = TextEditingController();
//   PdfTextSearchResult _pdfTextSearchResult = PdfTextSearchResult();
//   FocusNode? focusNode;

//   @override
//   void initState() {
//     super.initState();
//     focusNode = FocusNode();
//     focusNode?.requestFocus();
//   }

//   @override
//   void dispose() {
//     focusNode?.dispose();
//     _pdfTextSearchResult.removeListener(() {});
//     super.dispose();
//   }

//   void clearSearch() {
//     _isSearchInitiated = false;
//     _pdfTextSearchResult.clear();
//   }

//   void _showSearchAlertDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Search Result'),
//           content: Text('No more occurrences found. Would you like to continue to search from the beginning?'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   _pdfTextSearchResult.nextInstance();
//                 });
//                 Navigator.of(context).pop();
//               },
//               child: Text('YES'),
//             ),
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   _pdfTextSearchResult.clear();
//                   _editingController.clear();
//                   _isSearchInitiated = false;
//                   focusNode?.requestFocus();
//                 });
//                 Navigator.of(context).pop();
//               },
//               child: Text('NO'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Material(
//           color: Colors.transparent,
//           child: IconButton(
//             icon: Icon(Icons.arrow_back),
//             onPressed: () {
//               widget.onTap?.call('Cancel Search');
//               _isSearchInitiated = false;
//               _editingController.clear();
//               _pdfTextSearchResult.clear();
//             },
//           ),
//         ),
//         Flexible(
//           child: TextFormField(
//             style: TextStyle(color: Colors.black87, fontSize: 16),
//             enableInteractiveSelection: false,
//             focusNode: focusNode,
//             keyboardType: TextInputType.text,
//             textInputAction: TextInputAction.search ,
//             controller: _editingController,
//             decoration: InputDecoration(
//               border: InputBorder.none,
//               hintText: 'Find...',
//               hintStyle: TextStyle(color: Colors.grey),
//             ),
//             onChanged: (text) {
//               if (_editingController.text.isNotEmpty) {
//                 setState(() {});
//               }
//             },
//             onFieldSubmitted: (String value) {
//               _isSearchInitiated = true;
//               _pdfTextSearchResult = widget.controller!.searchText(_editingController.text);
//               _pdfTextSearchResult.addListener(() {
//                 if (super.mounted) {
//                   setState(() {});
//                 }
//                 if (!_pdfTextSearchResult.hasResult && _pdfTextSearchResult.isSearchCompleted) {
//                   widget.onTap?.call('noResultFound');
//                 }
//               });
//             },
//           ),
//         ),
//         Visibility(
//           visible: _editingController.text.isNotEmpty,
//           child: Material(
//             color: Colors.transparent,
//             child: IconButton(
//               icon: Icon(Icons.clear),
//               onPressed: () {
//                 setState(() {
//                   _editingController.clear();
//                   _pdfTextSearchResult.clear();
//                   widget.controller!.clearSelection();
//                   _isSearchInitiated = false;
//                   focusNode!.requestFocus();
//                 });
//                 widget.onTap!.call('Clear Text');
//               },
//               tooltip: widget.showTooltip ? 'Clear Text' : null,
//             ),
//           ),
//         ),
//         Visibility(
//           visible: !_pdfTextSearchResult.isSearchCompleted && _isSearchInitiated,
//           child: Padding(
//             padding: const EdgeInsets.only(right: 10),
//             child: SizedBox(
//               width: 24,
//               height: 24,
//               child: CircularProgressIndicator(
//                 color: Theme.of(context).primaryColor,
//               ),
//             ),
//           ),
//         ),
//         Visibility(
//           visible: _pdfTextSearchResult.hasResult,
//           child: Row(
//             children: [
//               Text(
//                 '${_pdfTextSearchResult.currentInstanceIndex}',
//                 style: TextStyle(color: Colors.black87, fontSize: 16),
//               ),
//               Text(
//                 ' of ',
//                 style: TextStyle(color: Colors.black87, fontSize: 16),
//               ),
//               Text(
//                 '${_pdfTextSearchResult.totalInstanceCount}',
//                 style: TextStyle(color: Colors.black87, fontSize: 16),
//               ),
//               Material(
//                 color: Colors.transparent,
//                 child: IconButton(
//                   icon: Icon(Icons.navigate_before),
//                   onPressed: () {
//                     setState(() {
//                       _pdfTextSearchResult.previousInstance();
//                     });
//                     widget.onTap!.call('Previous Instance');
//                   },
//                   tooltip: widget.showTooltip ? 'Previous' : null,
//                 ),
//               ),
//               Material(
//                 color: Colors.transparent,
//                 child: IconButton(
//                   icon: Icon(Icons.navigate_next),
//                   onPressed: () {
//                     setState(() {
//                       if (_pdfTextSearchResult.currentInstanceIndex == _pdfTextSearchResult.totalInstanceCount &&
//                           _pdfTextSearchResult.currentInstanceIndex != 0 &&
//                           _pdfTextSearchResult.totalInstanceCount != 0 &&
//                           _pdfTextSearchResult.isSearchCompleted) {
//                         _showSearchAlertDialog(context);
//                       } else {
//                         widget.controller!.clearSelection();
//                         _pdfTextSearchResult.nextInstance();
//                       }
//                     });
//                     widget.onTap!.call('Next Instance');
//                   },
//                   tooltip: widget.showTooltip ? 'Next' : null,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }