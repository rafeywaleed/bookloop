import 'dart:async';
import 'dart:io';
import 'package:bookloop/pdf/pdf_appbar.dart';
import 'package:bookloop/pdf/pdf_navbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_html/flutter_html.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerPage extends StatefulWidget {
  final String filePath;

  PdfViewerPage({required this.filePath});
  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage>
    with SingleTickerProviderStateMixin {
  //from sync site
  PdfViewerController _pdfViewerController = PdfViewerController();
  final GlobalKey<SearchToolbarState> _textSearchKey = GlobalKey();
  bool _showToolbar = false;
  bool _showScrollHead = true;
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  LocalHistoryEntry? _historyEntry;

  int _currentPage = 1;
  int _totalPages = 0;
  bool _isHorizontalScroll = false;
  List<Bookmark> _bookmarks = [];
  //PdfViewerController? _pdfViewerController;
  bool _isFullScreen = false;
  late PdfTextSearchResult _searchResult;

  @override
  void initState() {
    super.initState();
    _loadPdf();
    _searchResult = PdfTextSearchResult();
  }

  void _toggleScrollDirection() {
    setState(() {
      _isHorizontalScroll = !_isHorizontalScroll;
    });
  }

  void _searchPdf() {
    setState(() {
     // _showScrollHead = false;
      _showToolbar = true;
      _ensureHistoryEntry();
    });
  }

  void _openBookmarkView() {
    _pdfViewerKey.currentState?.openBookmarkView();
  }

  /// Ensure the entry history of text search.
  void _ensureHistoryEntry() {
    if (_historyEntry == null) {
      final ModalRoute<dynamic>? route = ModalRoute.of(context);
      if (route != null) {
        _historyEntry = LocalHistoryEntry(onRemove: _handleHistoryEntryRemoved);
        route.addLocalHistoryEntry(_historyEntry!);
      }
    }
  }

  double _zoomLevel = 1;

  void _onZoomLevelChange(double newZoom){
    setState(() {
      _zoomLevel = newZoom;
    });
  }

  bool get showToolbar {
    return _showToolbar;
  }

  /// Remove history entry for text search.
  void _handleHistoryEntryRemoved() {
    _textSearchKey.currentState?.clearSearch();
    setState(() {
      _showToolbar = false;
    });
    _historyEntry = null;
  }

  Annotation? _selectedAnnotation;

  void listAllAnnotations() {
    List<Annotation> annotations = _pdfViewerController.getAnnotations();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          child: ListView.builder(
            itemCount: annotations.length,
            itemBuilder: (context, index) {
              final annotation = annotations[index];
              int pageNumber = annotation.pageNumber;

              return ListTile(
                title: Text('${annotation.runtimeType} on '),
                subtitle: Text('Pg no: $pageNumber'),
                onTap: () {
                  selectAnnotation(annotation);
                  Navigator.pop(context); // Close the modal sheet
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _editAnnotation(annotation);
                        Navigator.pop(context); // Close the modal sheet
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteAnnotation(annotation);
                        Navigator.pop(context); // Close the modal sheet
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _editAnnotation(Annotation annotation) {
    // Example: Change the color of the annotation (if applicable)
    if (annotation is HighlightAnnotation) {
      // Show a dialog to choose a new color or other properties
      // This is a simple example; you can customize it further
      showDialog(
        context: context,
        builder: (BuildContext context) {
          Color newColor = Colors.yellow; // Default color
          return AlertDialog(
            title: Text('Edit Annotation'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Color picker or other editing options can be added here
                Text('Choose a color for the annotation:'),
                // Example: Color selection (you can implement a color picker)
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // Update the annotation color
                  annotation.color = newColor; // Set to the chosen color
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Save'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
            ],
          );
        },
      );
    }
  }

  void _deleteAnnotation(Annotation annotation) {
    _pdfViewerController.removeAnnotation(annotation);
    // Optionally show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Annotation deleted')),
    );
  }

  void addHighlightAnnotation() {
    List<PdfTextLine>? textLines = _pdfViewerKey.currentState?.getSelectedTextLines();
    if (textLines != null && textLines.isNotEmpty) {
      final HighlightAnnotation highlightAnnotation = HighlightAnnotation(
        textBoundsCollection: textLines,
      );
      _pdfViewerController.addAnnotation(highlightAnnotation);
    }
  }
  void removeFirstAnnotation() {
    // Get the list of annotations in the PDF document.
    List<Annotation> annotations = _pdfViewerController.getAnnotations();
    if (annotations.isNotEmpty) {
      // Get the first annotation from the PDF document.
      Annotation firstAnnotation = annotations.first;
      // Remove the first annotation from the PDF document.
      _pdfViewerController.removeAnnotation(firstAnnotation);
    }
  }

//TODO use remove annotations properly

  void removeAllAnnotations() {
    // Remove all the annotations from the PDF document.
    _pdfViewerController.removeAllAnnotations();
  }

  void removeAllAnnotationsInFirstPage() {
    // Remove all the annotations in the first page of the PDF document.
    _pdfViewerController.removeAllAnnotations(pageNumber: 1);
  }

  void editAnnotation() {
    // Get the list of annotations in the PDF document.
    List<Annotation> annotations = _pdfViewerController.getAnnotations();

    if (annotations.isNotEmpty) {
      // Get the first annotation from the PDF document.
      Annotation firstAnnotation = annotations.first;
      // Edit the first annotation in the PDF document.
      firstAnnotation.color = Colors.red; // Change the color of the annotation.
      firstAnnotation.opacity = 0.5; // Change the opacity of the annotation.
    }
  }

  void selectFirstAnnotation() {
    // Get the list of annotations in the PDF document.
    List<Annotation> annotations = _pdfViewerController.getAnnotations();
    if (annotations.isNotEmpty) {
      // Get the first annotation from the PDF document.
      Annotation firstAnnotation = annotations.first;
      // Select the first annotation in the PDF document.
      _pdfViewerController.selectAnnotation(firstAnnotation);
    }
  }

  void customizeSelectorAppearance() {
    PdfAnnotationSettings annotationSettings =
        _pdfViewerController.annotationSettings;
    // For unlocked annotations.
    annotationSettings.selector.color = Colors.blue;
    // For locked annotations.
    annotationSettings.selector.lockedColor = Colors.grey;
  }

  void deselectAnnotation(Annotation annotation) {
    _pdfViewerController.deselectAnnotation(annotation);
    if (_selectedAnnotation == annotation) {
      _selectedAnnotation =
          null; // Clear the selected annotation if it's the one being deselected
    }
  }

  void selectAnnotation(Annotation selectedAnnotation) {
    // Deselect the selected annotation.
    _pdfViewerController.selectAnnotation(selectedAnnotation);
  }

//  void deselectCurrentAnnotation() {
//     Annotation? selectedAnnotation = _pdfViewerController.selectedAnnotation;
//     if (selectedAnnotation != null) {
//       deselectAnnotation(selectedAnnotation);
//     }
//   }

  void lockAllAnnotations() {
    // Lock all the annotations in the PDF document.
    _pdfViewerController.annotationSettings.isLocked = true;
  }

  void lockFirstAnnotation() {
    // Get the list of annotations in the PDF document.
    List<Annotation> annotations = _pdfViewerController.getAnnotations();
    if (annotations.isNotEmpty) {
      // Get the first annotation from the PDF document.
      Annotation firstAnnotation = annotations.first;
      // Lock the first annotation in the PDF document.
      firstAnnotation.isLocked = true;
    }
  }

  void lockUnderlineAnnotations() {
    // Get the underline annotation settings.
    PdfTextMarkupAnnotationSettings underlineAnnotationSettings =
        _pdfViewerController.annotationSettings.underline;
    // Lock all the underline annotations in the PDF document.
    underlineAnnotationSettings.isLocked = true;
  }

  void lockSelectedAnnotation(Annotation selectedAnnotation) {
    // Lock the selected annotation.
    selectedAnnotation.isLocked = true;
  }

  void enableStickyNoteAnnotationMode() {
    // Enable the sticky note annotation mode.
    _pdfViewerController.annotationMode = PdfAnnotationMode.stickyNote;
  }

  void disableAnnotationMode() {
    // Disable or deactivate the annotation mode.
    _pdfViewerController.annotationMode = PdfAnnotationMode.none;
  }

   void addStickyNoteAnnotation() {
    final StickyNoteAnnotation stickyNote = StickyNoteAnnotation(
      pageNumber: 1, // Change this to the current page number
      text: 'This is a sticky note annotation',
      icon: PdfStickyNoteIcon.comment,
      position: Offset(100, 100), // Set a default position
    );
    _pdfViewerController.addAnnotation(stickyNote);
  }

  

  void customizeDefaultStickyNoteSettings() {
    // Obtain the default sticky note annotation settings from the PdfViewerController instance.
    PdfStickyNoteAnnotationSettings stickyNoteSettings =
        _pdfViewerController.annotationSettings.stickyNote;

    // Modify the default properties.
    stickyNoteSettings.icon =
        PdfStickyNoteIcon.comment; // Set the default icon to Comment.
    stickyNoteSettings.color = Colors.yellow; //Stroke color
    stickyNoteSettings.opacity = 0.75; // 75% Opacity
  }

  void editSelectedStickyNoteAnnotation(Annotation selectedAnnotation) {
    if (selectedAnnotation is StickyNoteAnnotation) {
      // Change the icon of the selected sticky note annotation to Note.
      selectedAnnotation.icon = PdfStickyNoteIcon.note;

      // Change the text of the selected sticky note annotation.
      selectedAnnotation.text = "Changed the comment to note.";
    }
  }

bool _nightMode = false;
  Color _highlightColor = Colors.yellow; 
  void _toggleNightMode() {
    setState(() {
      _nightMode = !_nightMode;
    });
  }
    void _changeHighlightColor(Color color) {
    setState(() {
      _highlightColor = color;
    });
  }


  Future<void> _loadPdf() async {
    _pdfViewerController = PdfViewerController();
    _totalPages = await _pdfViewerController?.pageCount ?? 0;
    setState(() {});
  }

  void _addBookmark() {
    if (_pdfViewerController != null) {
      final Bookmark bookmark = Bookmark(
        text: 'Bookmark ${_bookmarks.length + 1}',
        page: _currentPage,
      );
      setState(() {
        _bookmarks.add(bookmark);
      });
    }
  }

  void _viewBookmarks() {
    if (_pdfViewerController != null && _bookmarks.isNotEmpty) {
      _pdfViewerController?.jumpToPage(_bookmarks[0].page);
    }
  }

  double _currentZoomLevel = 1.0;

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
     // _showScrollHead = _isFullScreen;

      if (_isFullScreen) {
        // Save current zoom level when entering fullscreen
        _currentZoomLevel = _pdfViewerController.zoomLevel;
      } else {
        // Restore zoom level when exiting fullscreen
        _pdfViewerController.zoomLevel = _currentZoomLevel;
      }
    });
  }

  // void _searchPdf() async {
  //   final String? searchTerm = await showDialog<String>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Search PDF'),
  //         content: TextField(
  //           autofocus: true,
  //           decoration: InputDecoration(
  //             labelText: 'Search Term',
  //             border: OutlineInputBorder(),
  //           ),
  //           onSubmitted: (value) {
  //             Navigator.of(context).pop(value);
  //           },
  //         ),
  //       );
  //     },
  //   );

  //   if (searchTerm != null && searchTerm.isNotEmpty) {
  //     final result = await _pdfViewerController?.searchText(
  //       searchTerm,
  //       searchOption: TextSearchOption.caseSensitive,
  //     );

  //     if (result != null) {
  //       print(
  //           'Total Instances: ${result.totalInstanceCount}'); // Debugging line
  //       _searchResult = result;
  //       if (_searchResult.totalInstanceCount > 0) {
  //         _showSearchResult(searchTerm);
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('No results found for "$searchTerm"')),
  //         );
  //       }
  //     }
  //   }
  // }

  // void _showSearchResult(String searchTerm) {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return SearchToolbar(
  //         controller: _pdfViewerController,
  //         searchResult: _searchResult,
  //         searchTerm: searchTerm,
  //       );
  //     },
  //   );
  // }
  final UndoHistoryController _undoController = UndoHistoryController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        // appBar: _isFullScreen
        // ? null
        // : PdfAppBar(
        //     controller: _pdfViewerController,
        //     onSearchTap: () {
        //       setState(() {
        //         _showScrollHead = false;
        //         _showToolbar = true;
        //         _ensureHistoryEntry();
        //       });
        //     },
        //     onFullscreenTap: _toggleFullScreen,
        //     onBookmarkTap: _openBookmarkView,
        //     onAnnotationsTap: listAllAnnotations,
        //     onUndoTap: _undoController.value.canUndo ? _undoController.undo : (){},
        //     onRedoTap: _undoController.value.canRedo ? _undoController.redo : (){},
        //     appBarHeight: MediaQuery.of(context).size.height*0.15,
        //   ),
        body: Stack(
          children: [
            SfPdfViewer.file(

              
              File(widget.filePath),
             onZoomLevelChanged: (PdfZoomDetails details) {
              _onZoomLevelChange(details.newZoomLevel);
            },
              onTap: (PdfGestureDetails details) {
                print('${details.pageNumber}');
                _toggleFullScreen();
              },
              canShowHyperlinkDialog: true,
              canShowPageLoadingIndicator: true,
              canShowScrollStatus: true,
              canShowPaginationDialog: true,
              canShowPasswordDialog: true,
              canShowSignaturePadDialog: true,
              canShowTextSelectionMenu: true,
              // currentSearchTextHighlightColor: ,
              enableDoubleTapZooming: true,
              enableHyperlinkNavigation: true,
              enableTextSelection: true,

              enableDocumentLinkAnnotation: true,
              onHyperlinkClicked: (PdfHyperlinkClickedDetails details) {
                print(details.uri);
              },
              onAnnotationAdded: (Annotation annotation) {
                print('${annotation.runtimeType} is added successfully');
              },
              onAnnotationRemoved: (Annotation annotation) {
                print('${annotation.runtimeType} is removed successfully');
              },
              onAnnotationEdited: (Annotation annotation) {
                // Instance of the edited annotation.
                Annotation editedAnnotation = annotation;
              },
              onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                final List<Annotation> annotations =
                    _pdfViewerController.getAnnotations();
                if (annotations.isNotEmpty) {
                  // Gets the first annotation from the collection.
                  final Annotation annotation = annotations.first;
                  if (annotation is HighlightAnnotation) {
                    final Color color = annotation.color;
                    final double opacity = annotation.opacity;
                  }
                }
              },
              onAnnotationSelected: (Annotation annotation) {
                // Instance of the selected annotation.
                Annotation selectedAnnotation = annotation;
              },
              onAnnotationDeselected: (Annotation annotation) {
                // Instance of the deselected annotation.
                Annotation deselectedAnnotation = annotation;
              },
              undoController: _undoController,
              pageLayoutMode: PdfPageLayoutMode.single,
              controller: _pdfViewerController,
              canShowScrollHead: _showScrollHead,
              key: _pdfViewerKey,
              scrollDirection: _isHorizontalScroll
                  ? PdfScrollDirection.horizontal
                  : PdfScrollDirection.vertical,
              onPageChanged: (PdfPageChangedDetails details) {
                setState(() {
                  _currentPage = details.newPageNumber;
                   _pdfViewerController.zoomLevel = _zoomLevel;
                });
              },
            ),
            Visibility(
              visible: _textSearchKey.currentState?._showToast ?? false,
              child: Align(
                alignment: Alignment.center,
                child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                          left: 15, top: 7, right: 15, bottom: 7),
                      decoration: BoxDecoration(
                        color: Colors.grey[600],
                        borderRadius: BorderRadius.all(
                          Radius.circular(16.0),
                        ),
                      ),
                      child: Text(
                        'No result',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //Appbar
            _isFullScreen
                ? SizedBox.shrink()
                : Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: PdfAppBar(

                      title: 'Pdf',
                      showToolBar: _showToolbar,
                      controller: _pdfViewerController,
                      onSearchTap: _searchPdf,
                      onToggleScrollDir: _toggleScrollDirection,
                      onFullscreenTap: _toggleFullScreen,
                      onBookmarkTap: _openBookmarkView,
                      onAnnotationsTap: listAllAnnotations,
                      onUndoTap: _undoController.value.canUndo
                          ? _undoController.undo
                          : () {},
                      onRedoTap: _undoController.value.canRedo
                          ? _undoController.redo
                          : () {},
                      appBarHeight: MediaQuery.of(context).size.height * 0.15,
                      isHorizontalScroll: _isHorizontalScroll,
                    ),
                  ),
                   if (!_isFullScreen)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: PdfNavbar(
                  onToggleNightMode: _toggleNightMode,
                  onHighlightColorChange: _changeHighlightColor,
                  onAddStickyNote: addStickyNoteAnnotation,
                  onListAllAnnotations: listAllAnnotations,
                ),
              ),

            // // The NavBar
            // _isFullScreen
            //     ? SizedBox.shrink() 
            //     : Positioned(
            //         bottom: 0,
            //         left: 0,
            //         right: 0,
            //         child: BottomAppBar(
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //             children: [
            //               IconButton(
            //                 icon: Icon(Icons.brightness_6),
            //                 onPressed: _toggleNightMode,
            //               ),
            //               IconButton(
            //                 icon: Icon(Icons.highlight),
            //                 onPressed: addHighlightAnnotation,
            //               ),
            //               IconButton(
            //                 icon: Icon(Icons.note_add),
            //                 onPressed: addStickyNoteAnnotation,
            //               ),
            //               IconButton(
            //                 icon: Icon(Icons.format_list_bulleted),
            //                 onPressed: listAllAnnotations,
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
          ],
        ),
        // bottomNavigationBar: _isFullScreen
        //     ? null
        //     : BottomAppBar(
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //           children: [
        //             IconButton(
        //               icon: Icon(Icons.brightness_6),
        //               onPressed: _toggleNightMode,
        //             ),
        //             IconButton(
        //               icon: Icon(Icons.highlight),
        //               onPressed: addHighlightAnnotation,
        //             ),
        //             IconButton(
        //               icon: Icon(Icons.note_add),
        //               onPressed: addStickyNoteAnnotation,
        //             ),
        //             IconButton(
        //               icon: Icon(Icons.format_list_bulleted),
        //               onPressed: listAllAnnotations,
        //             ),
        //           ],
        //         ),
        //       ),
        floatingActionButton: _isFullScreen
            ? FloatingActionButton(
                backgroundColor: Colors.white.withOpacity(1),
                onPressed: _toggleFullScreen,
                child: Icon(
                  Icons.fullscreen_exit,
                  color: Colors.purple.withOpacity(01),
                ),
                mini: true,
              )
            : null,
      ),
    );
  }
}

class Bookmark {
  String text;
  int page;

  Bookmark({required this.text, required this.page});
}

/// Signature for the [SearchToolbar.onTap] callback.
typedef SearchTapCallback = void Function(Object item);

/// SearchToolbar widget
class SearchToolbar extends StatefulWidget {
  ///it describe the search toolbar constructor
  const SearchToolbar({
    this.controller,
    this.onTap,
    this.showTooltip = true,
    super.key,
  });

  /// Indicates whether the tooltip for the search toolbar items need to be shown or not.
  final bool showTooltip;

  /// An object that is used to control the [SfPdfViewer].
  final PdfViewerController? controller;

  /// Called when the search toolbar item is selected.
  final SearchTapCallback? onTap;

  @override
  SearchToolbarState createState() => SearchToolbarState();
}

/// State for the SearchToolbar widget
class SearchToolbarState extends State<SearchToolbar> {
  /// Indicates whether search is initiated or not.
  bool _isSearchInitiated = false;

  /// Indicates whether search toast need to be shown or not.
  bool _showToast = false;

  ///An object that is used to retrieve the current value of the TextField.
  final TextEditingController _editingController = TextEditingController();

  /// An object that is used to retrieve the text search result.
  PdfTextSearchResult _pdfTextSearchResult = PdfTextSearchResult();

  ///An object that is used to obtain keyboard focus and to handle keyboard events.
  FocusNode? focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    focusNode?.requestFocus();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    focusNode?.dispose();
    _pdfTextSearchResult.removeListener(() {});
    super.dispose();
  }

  ///Clear the text search result
  void clearSearch() {
    _isSearchInitiated = false;
    _pdfTextSearchResult.clear();
  }

  ///Display the Alert dialog to search from the beginning
  void _showSearchAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.all(0),
          title: Text('Search Result'),
          content: Container(
              width: 328.0,
              child: Text(
                  'No more occurrences found. Would you like to continue to search from the beginning?')),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  _pdfTextSearchResult.nextInstance();
                });
                Navigator.of(context).pop();
              },
              child: Text(
                'YES',
                style: TextStyle(
                    color: Color(0x00000000).withOpacity(0.87),
                    fontFamily: 'Roboto',
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.none),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _pdfTextSearchResult.clear();
                  _editingController.clear();
                  _isSearchInitiated = false;
                  focusNode?.requestFocus();
                });
                Navigator.of(context).pop();
              },
              child: Text(
                'NO',
                style: TextStyle(
                    color: Color(0x00000000).withOpacity(0.87),
                    fontFamily: 'Roboto',
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.none),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Material(
          color: Colors.transparent,
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Color(0x00000000).withOpacity(0.54),
              size: 24,
            ),
            onPressed: () {
              widget.onTap?.call('Cancel Search');
              _isSearchInitiated = false;
              _editingController.clear();
              _pdfTextSearchResult.clear();
            },
          ),
        ),
        Flexible(
          child: TextFormField(
            style: TextStyle(
                color: Color(0x00000000).withOpacity(0.87), fontSize: 16),
            enableInteractiveSelection: false,
            focusNode: focusNode,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.search,
            controller: _editingController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Find...',
              hintStyle: TextStyle(color: Color(0x00000000).withOpacity(0.34)),
            ),
            onChanged: (text) {
              if (_editingController.text.isNotEmpty) {
                setState(() {});
              }
            },
            onFieldSubmitted: (String value) {
              if (kIsWeb) {
                _pdfTextSearchResult =
                    widget.controller!.searchText(_editingController.text);
                if (_pdfTextSearchResult.totalInstanceCount == 0) {
                  widget.onTap?.call('noResultFound');
                }
                setState(() {});
              } else {
                _isSearchInitiated = true;
                _pdfTextSearchResult =
                    widget.controller!.searchText(_editingController.text);
                _pdfTextSearchResult.addListener(() {
                  if (super.mounted) {
                    setState(() {});
                  }
                  if (!_pdfTextSearchResult.hasResult &&
                      _pdfTextSearchResult.isSearchCompleted) {
                    widget.onTap?.call('noResultFound');
                  }
                });
              }
            },
          ),
        ),
        Visibility(
          visible: _editingController.text.isNotEmpty,
          child: Material(
            color: Colors.transparent,
            child: IconButton(
              icon: Icon(
                Icons.clear,
                color: Color.fromRGBO(0, 0, 0, 0.54),
                size: 24,
              ),
              onPressed: () {
                setState(() {
                  _editingController.clear();
                  _pdfTextSearchResult.clear();
                  widget.controller!.clearSelection();
                  _isSearchInitiated = false;
                  focusNode!.requestFocus();
                });
                widget.onTap!.call('Clear Text');
              },
              tooltip: widget.showTooltip ? 'Clear Text' : null,
            ),
          ),
        ),
        Visibility(
          visible:
              !_pdfTextSearchResult.isSearchCompleted && _isSearchInitiated,
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
        Visibility(
          visible: _pdfTextSearchResult.hasResult,
          child: Row(
            children: [
              Text(
                '${_pdfTextSearchResult.currentInstanceIndex}',
                style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 0.54).withOpacity(0.87),
                    fontSize: 16),
              ),
              Text(
                ' of ',
                style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 0.54).withOpacity(0.87),
                    fontSize: 16),
              ),
              Text(
                '${_pdfTextSearchResult.totalInstanceCount}',
                style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 0.54).withOpacity(0.87),
                    fontSize: 16),
              ),
              Material(
                color: Colors.transparent,
                child: IconButton(
                  icon: Icon(
                    Icons.navigate_before,
                    color: Color.fromRGBO(0, 0, 0, 0.54),
                    size: 24,
                  ),
                  onPressed: () {
                    setState(() {
                      _pdfTextSearchResult.previousInstance();
                    });
                    widget.onTap!.call('Previous Instance');
                  },
                  tooltip: widget.showTooltip ? 'Previous' : null,
                ),
              ),
              Material(
                color: Colors.transparent,
                child: IconButton(
                  icon: Icon(
                    Icons.navigate_next,
                    color: Color.fromRGBO(0, 0, 0, 0.54),
                    size: 24,
                  ),
                  onPressed: () {
                    setState(() {
                      if (_pdfTextSearchResult.currentInstanceIndex ==
                              _pdfTextSearchResult.totalInstanceCount &&
                          _pdfTextSearchResult.currentInstanceIndex != 0 &&
                          _pdfTextSearchResult.totalInstanceCount != 0 &&
                          _pdfTextSearchResult.isSearchCompleted) {
                        _showSearchAlertDialog(context);
                      } else {
                        widget.controller!.clearSelection();
                        _pdfTextSearchResult.nextInstance();
                      }
                    });
                    widget.onTap!.call('Next Instance');
                  },
                  tooltip: widget.showTooltip ? 'Next' : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
