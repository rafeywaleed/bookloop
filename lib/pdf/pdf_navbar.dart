import 'package:flutter/material.dart';

class PdfNavbar extends StatelessWidget {
  final VoidCallback onToggleNightMode;
  final Function(Color) onHighlightColorChange;
  final VoidCallback onAddStickyNote;
  final VoidCallback onListAllAnnotations;

  const PdfNavbar({
    Key? key,
    required this.onToggleNightMode,
    required this.onHighlightColorChange,
    required this.onAddStickyNote,
    required this.onListAllAnnotations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
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
            blurRadius: 4.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.brightness_6, color: Colors.white),
            onPressed: onToggleNightMode,
          ),
          DropdownButton<Color>(
            icon: Icon(Icons.color_lens, color: Colors.white),
            items: [
              DropdownMenuItem(
                value: Colors.yellow,
                child: Text('Yellow', style: TextStyle(color: Colors.yellow)),
              ),
              DropdownMenuItem(
                value: Colors.red,
                child: Text('Red', style: TextStyle(color: Colors.red)),
              ),
              DropdownMenuItem(
                value: Colors.green,
                child: Text('Green', style: TextStyle(color: Colors.green)),
              ),
              DropdownMenuItem(
                value: Colors.blue,
                child: Text('Blue', style: TextStyle(color: Colors.blue)),
              ),
            ],
            onChanged: (color) {
              if (color != null) {
                onHighlightColorChange(color);
              }
            },
            hint: Text('Highlight Color', style: TextStyle(color: Colors.white)),
          ),
          IconButton(
            icon: Icon(Icons.note_add, color: Colors.white),
            onPressed: onAddStickyNote,
          ),
          IconButton(
            icon: Icon(Icons.format_list_bulleted, color: Colors.white),
            onPressed: onListAllAnnotations,
          ),
        ],
      ),
    );
  }
}