import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfAppBar extends StatefulWidget implements PreferredSizeWidget {
  final PdfViewerController controller;
  final VoidCallback onToggleScrollDir;
  final VoidCallback onSearchTap;
  final VoidCallback onFullscreenTap;
  final VoidCallback onBookmarkTap;
  final VoidCallback onAnnotationsTap;
  final VoidCallback onUndoTap;
  final VoidCallback onRedoTap;
  final double appBarHeight;
  final bool isHorizontalScroll;
  final bool showToolBar;
  final String title;
  final List<Widget> actions;
  final Widget? leading;
  final Widget? titleWidget;

  PdfAppBar({
    required this.controller,
    required this.onToggleScrollDir,
    required this.onSearchTap,
    required this.onFullscreenTap,
    required this.onBookmarkTap,
    required this.onAnnotationsTap,
    required this.onUndoTap,
    required this.onRedoTap,
    required this.appBarHeight,
    required this.isHorizontalScroll,
    required this.showToolBar,
    required this.title,
    this.actions = const [],
    this.leading,
    this.titleWidget,
  });

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);

  @override
  State<PdfAppBar> createState() => _PdfAppBarState();
}

class _PdfAppBarState extends State<PdfAppBar> {
  final GlobalKey<SearchToolbarState> _textSearchKey = GlobalKey();
  bool showToolbar = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.appBarHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(255, 125, 113, 71).withOpacity(0.8),
            const Color.fromARGB(255, 122, 102, 40).withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: widget.showToolBar
          ? SafeArea(
              child: SearchToolbar(
                key: _textSearchKey,
                showTooltip: true,
                controller: widget.controller,
                onTap: (Object toolbarItem) async {
                  if (toolbarItem.toString() == 'Cancel Search') {
                    setState(() {
                      showToolbar = false;
                      if (Navigator.canPop(context)) {
                        Navigator.maybePop(context);
                      }
                    });
                  }
                },
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.leading ?? Container(),
                widget.titleWidget ?? Text(
                  widget.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    ...widget.actions,
                    _buildIconButton(Icons.view_agenda, widget.onToggleScrollDir),
                    _buildIconButton(Icons.search, widget.onSearchTap),
                    _buildIconButton(Icons.fullscreen, widget.onFullscreenTap),
                    _buildIconButton(Icons.bookmark, widget.onBookmarkTap),
                    _buildIconButton(Icons.list, widget.onAnnotationsTap),
                  ],
                ),
              ],
            ),
    );
  }

  IconButton _buildIconButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon, color: Colors.white),
      onPressed: onPressed,
      tooltip: 'Tap to ${icon.toString().split('.').last.replaceAll('Icons.', '')}',
      splashColor: Colors.white.withOpacity(0.3),
    );
  }
}

typedef SearchTapCallback = void Function(Object item);

class SearchToolbar extends StatefulWidget {
  const SearchToolbar({
    this.controller,
    this.onTap,
    this.showTooltip = true,
    super.key,
  });

  final bool showTooltip;
  final PdfViewerController? controller;
  final SearchTapCallback? onTap;

  @override
  SearchToolbarState createState() => SearchToolbarState();
}

class SearchToolbarState extends State<SearchToolbar> {
  bool _isSearchInitiated = false;
  final TextEditingController _editingController = TextEditingController();
  PdfTextSearchResult _pdfTextSearchResult = PdfTextSearchResult();
  FocusNode? focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    focusNode?.requestFocus();
  }

  @override
  void dispose() {
    focusNode?.dispose();
    _pdfTextSearchResult.removeListener(() {});
    super.dispose();
  }

  void clearSearch() {
    _isSearchInitiated = false;
    _pdfTextSearchResult.clear();
  }

  void _showSearchAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Search Result', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text('No more occurrences found. Would you like to continue searching from the beginning?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  _pdfTextSearchResult.nextInstance();
                });
                Navigator.of(context).pop();
              },
              child: Text('YES'),
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
              child: Text('NO'),
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
        IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            widget.onTap?.call('Cancel Search');
            _isSearchInitiated = false;
            _editingController.clear();
            _pdfTextSearchResult.clear();
          },
        ),
        Expanded(
          child: TextFormField(
            style: TextStyle(color: Colors.white, fontSize: 16),
            focusNode: focusNode,
            controller: _editingController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Find...',
              hintStyle: TextStyle(color: Colors.white54),
            ),
            onChanged: (text) {
              setState(() {});
            },
            onFieldSubmitted: (String value) {
              _isSearchInitiated = true;
              _pdfTextSearchResult = widget.controller!.searchText(_editingController.text);
              _pdfTextSearchResult.addListener(() {
                if (mounted) {
                  setState(() {});
                }
                if (!_pdfTextSearchResult.hasResult && _pdfTextSearchResult.isSearchCompleted) {
                  widget.onTap?.call('noResultFound');
                }
              });
            },
          ),
        ),
        Visibility(
          visible: _editingController.text.isNotEmpty,
          child: IconButton(
            icon: Icon(Icons.clear, color: Colors.white),
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
          ),
        ),
        Visibility(
          visible: !_pdfTextSearchResult.isSearchCompleted && _isSearchInitiated,
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
        Visibility(
          visible: _pdfTextSearchResult.hasResult,
          child: Row(
            children: [
              Text('${_pdfTextSearchResult.currentInstanceIndex}', style: TextStyle(color: Colors.white)),
              Text(' of ', style: TextStyle(color: Colors.white)),
              Text('${_pdfTextSearchResult.totalInstanceCount}', style: TextStyle(color: Colors.white)),
              IconButton(
                icon: Icon(Icons.navigate_before, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _pdfTextSearchResult.previousInstance();
                  });
                  widget.onTap!.call('Previous Instance');
                },
              ),
              IconButton(
                icon: Icon(Icons.navigate_next, color: Colors.white),
                onPressed: () {
                  setState(() {
                    if (_pdfTextSearchResult.currentInstanceIndex == _pdfTextSearchResult.totalInstanceCount &&
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
              ),
            ],
          ),
        ),
      ],
    );
  }
}
