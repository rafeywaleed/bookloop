// use UI of this code
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileEditPage extends StatefulWidget {
  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  String profileImage = "";
  String name = "Abdul Rafey Waleed";
  String username = "@rafeywaleed_a5";
  String bio = "Bio me kuch to bhi ek add karna\nBio me kuch to bhi ek add karna";

  final TextEditingController _bioController = TextEditingController();

  List<Map<String, String>> booksRead = [];
  List<Map<String, String>> favoriteBooks = [];

  @override
  void initState() {
    super.initState();
    _bioController.text = bio;
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      booksRead = (prefs.getStringList('booksRead') ?? [])
          .map((e) => Map<String, String>.from(json.decode(e)))
          .toList();
      favoriteBooks = (prefs.getStringList('favoriteBooks') ?? [])
          .map((e) => Map<String, String>.from(json.decode(e)))
          .toList();
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'booksRead',
      booksRead.map((e) => json.encode(e)).toList(),
    );
    await prefs.setStringList(
      'favoriteBooks',
      favoriteBooks.map((e) => json.encode(e)).toList(),
    );
  }

  void _addBook(String title, String coverUrl) {
    setState(() {
      booksRead.add({'title': title, 'cover': coverUrl});
    });
    _saveData();
  }

  void _addFavoriteBook(String title, String coverUrl) {
    setState(() {
      if (!favoriteBooks.any((book) => book['title'] == title)) {
        favoriteBooks.add({'title': title, 'cover': coverUrl});
      }
    });
    _saveData();
  }

  Future<void> _showBookSearchDialog() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => BookSearchDialog(),
    );
    if (result != null) {
      _addBook(result['title']!, result['cover']!);
    }
  }

  Future<void> _showFavoriteBookSelector() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        return FavoriteBookSelectorDialog(booksRead: booksRead);
      },
    );
    if (result != null) {
      _addFavoriteBook(result['title']!, result['cover']!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Section
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.brown,
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                username,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 8),
                              TextField(
                                controller: _bioController,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Write your bio...',
                                ),
                                onChanged: (value) => bio = value,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Books Read Section
            Expanded(
              child: ListView(
                children: [
                  _buildSection(
                    title: 'Books read by $username',
                    books: booksRead,
                    onAdd: _showBookSearchDialog,
                  ),
                  SizedBox(height: 16),
                  _buildSection(
                    title: 'Fav books of $username',
                    books: favoriteBooks,
                    onAdd: _showFavoriteBookSelector,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Map<String, String>> books,
    required VoidCallback onAdd,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              GestureDetector(
                onTap: onAdd,
                child: Container(
                  width: 80,
                  margin: EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[300],
                  ),
                  child: Icon(Icons.add, size: 40),
                ),
              ),
              ...books.map((book) {
                return Container(
                  width: 80,
                  margin: EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(book['cover']!),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }
}

class BookSearchDialog extends StatefulWidget {
  @override
  _BookSearchDialogState createState() => _BookSearchDialogState();
}

class _BookSearchDialogState extends State<BookSearchDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> searchResults = [];

  Future<void> _searchBooks(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }
    final response = await http.get(
      Uri.parse('https://www.googleapis.com/books/v1/volumes?q=$query'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        searchResults = List<Map<String, String>>.from(data['items'].map((book) {
          final volumeInfo = book['volumeInfo'];
          return {
            'title': volumeInfo['title'],
            'cover': volumeInfo['imageLinks']?['thumbnail'] ??
                'https://via.placeholder.com/80x120.png?text=No+Image',
          };
        }));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search for books',
                border: OutlineInputBorder(),
              ),
              onChanged: _searchBooks,
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final book = searchResults[index];
                  return ListTile(
                    leading: Image.network(
                      book['cover']!,
                      width: 40,
                      fit: BoxFit.cover,
                    ),
                    title: Text(book['title']!),
                    onTap: () => Navigator.pop(context, book),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoriteBookSelectorDialog extends StatelessWidget {
  final List<Map<String, String>> booksRead;

  FavoriteBookSelectorDialog({required this.booksRead});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ListView.builder(
        itemCount: booksRead.length,
        itemBuilder: (context, index) {
          final book = booksRead[index];
          return ListTile(
            leading: Image.network(
              book['cover']!,
              width: 40,
              fit: BoxFit.cover,
            ),
            title: Text(book['title']!),
            onTap: () => Navigator.pop(context, book),
          );
        },
      ),
    );
  }
}

//and functionalities of search etc of this code
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class ProfileEditPage extends StatefulWidget {
//   @override
//   _ProfileEditPageState createState() => _ProfileEditPageState();
// }

// class _ProfileEditPageState extends State<ProfileEditPage> {
//   String profileImage = "";
//   String name = "Rafey Waleed";
//   String username = "@rafeywaleed_a5";

//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _usernameController = TextEditingController();
  
//   // Books read by user
//   List<String> booksRead = [];
//   List<String> favBooks = []; // Added for favorite books

//   @override
//   void initState() {
//     super.initState();
//     _nameController.text = name;
//     _usernameController.text = username;
//     _loadBooks();
//     _loadFavBooks(); // Load favorite books
//   }

//   // Load books from shared preferences
//   Future<void> _loadBooks() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       booksRead = prefs.getStringList('booksRead') ?? [];
//     });
//   }

//   // Load favorite books from shared preferences
//   Future<void> _loadFavBooks() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       favBooks = prefs.getStringList('favBooks') ?? [];
//     });
//   }

//   // Save books to shared preferences
//   Future<void> _saveBooks() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setStringList('booksRead', booksRead);
//   }

//   // Save favorite books to shared preferences
//   Future<void> _saveFavBooks() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setStringList('favBooks', favBooks);
//   }

//   // Search for a book using the Google Books API
//   Future<void> _searchBook(String query) async {
//     final response = await http.get(Uri.parse(
//         'https://www.googleapis.com/books/v1/volumes?q =$query'));

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       // Handle the search response
//       print(data);
//     } else {
//       print("Failed to load book data.");
//     }
//   }

//   // Add a book to the list
//   void _addBook(String bookName) {
//     setState(() {
//       booksRead.add(bookName);
//     });
//     _saveBooks();
//   }

//   // Add a favorite book from the read books
//   void _addFavBook(String bookName) {
//     setState(() {
//       favBooks.add(bookName);
//     });
//     _saveFavBooks();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFE4D9D3),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         title: Text(
//           'Edit Profile',
//           style: TextStyle(color: const Color(0xFF8D3F33)),
//         ),
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: Icon(
//               Icons.save,
//               color: const Color(0xFF8D3F33),
//             ),
//             onPressed: () {
//               setState(() {
//                 name = _nameController.text;
//                 username = _usernameController.text;
//               });
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             GestureDetector(
//               onTap: () {
//                 // Handle profile image update
//               },
//               child: CircleAvatar(
//                 radius: 60,
//                 backgroundImage: NetworkImage(profileImage),
//                 backgroundColor: const Color(0xFFEBCEA6),
//               ),
//             ),
//             const SizedBox(height: 20),
//             _buildTextField(_nameController, 'Name'),
//             const SizedBox(height: 16),
//             _buildTextField(_usernameController, 'Username'),
//             const SizedBox(height: 24),
//             Text(
//               'Books Read by $name',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: const Color(0xFF8D3F33),
//               ),
//             ),
//             const SizedBox(height: 12),
//             ElevatedButton(
//               onPressed: () async {
//                 final result = await showDialog<String>(
//                   context: context,
//                   builder: (context) {
//                     return BookSearchDialog(onBookSelected: _addBook);
//                   },
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFFC38560),
//               ),
//               child: const Text('Add Book'),
//             ),
//             const SizedBox(height: 12),
//             ElevatedButton(
//               onPressed: () async {
//                 final result = await showDialog<String>(
//                   context: context,
//                   builder: (context) {
//                     return BookSelectionDialog(booksRead: booksRead, onBookSelected: _addFavBook);
//                   },
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFFC38560),
//               ),
//               child: const Text('Add Favorite Book'),
//             ),
//             const SizedBox(height: 12),
//             ...booksRead.map((book) => ListTile(
//               contentPadding: const EdgeInsets.symmetric(vertical: 5),
//               title: Text(
//                 book,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                   color: Color.fromARGB(255, 65, 65, 65),
//                 ),
//               ),
//               leading: const Icon(Icons.book, color: Color(0xFF8D3F33)),
//               tileColor: const Color(0xFFEBCEA6),
//             )).toList(),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: const Color(0xFF445C74),
//         selectedItemColor: const Color(0xFFB64E3B),
//         unselectedItemColor: Colors.white,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//             backgroundColor: Color(0xFF445C74),
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.search),
//             label: 'Search',
//             backgroundColor: Color(0xFF445C74),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTextField(TextEditingController controller, String label) {
//     return TextField(
//       controller: controller,
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: TextStyle(color: const Color(0xFF8D3F33)),
//         border: OutlineInputBorder (
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(color: const Color(0xFF8D3F33)),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(color: const Color(0xFF8D3F33), width: 2),
//         ),
//       ),
//     );
//   }
// }

// class BookSearchDialog extends StatefulWidget {
//   final Function(String) onBookSelected;

//   BookSearchDialog({required this.onBookSelected});

//   @override
//   _BookSearchDialogState createState() => _BookSearchDialogState();
// }

// class _BookSearchDialogState extends State<BookSearchDialog> {
//   final TextEditingController _searchController = TextEditingController();
//   List<String> bookResults = [];

//   Future<void> _searchBooks(String query) async {
//     final response = await http.get(Uri.parse(
//         'https://www.googleapis.com/books/v1/volumes?q=$query'));

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       setState(() {
//         bookResults = List<String>.from(data['items']
//             .map((book) => book['volumeInfo']['title'])
//             .toList());
//       });
//     } else {
//       setState(() {
//         bookResults = [];
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: _searchController,
//               decoration: InputDecoration(labelText: 'Search for a book'),
//               onChanged: _searchBooks,
//             ),
//             const SizedBox(height: 10),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: bookResults.length,
//                 itemBuilder: (context, index) {
//                   final bookTitle = bookResults[index];
//                   return ListTile(
//                     title: Text(bookTitle),
//                     onTap: () {
//                       widget.onBookSelected(bookTitle);
//                       Navigator.pop(context);
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class BookSelectionDialog extends StatelessWidget {
//   final List<String> booksRead;
//   final Function(String) onBookSelected;

//   BookSelectionDialog({required this.booksRead, required this.onBookSelected});

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               'Select a Book from Read Books',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: booksRead.length,
//                 itemBuilder: (context, index) {
//                   final bookTitle = booksRead[index];
//                   return ListTile(
//                     title: Text(bookTitle),
//                     onTap: () {
//                       onBookSelected(bookTitle);
//                       Navigator.pop(context);
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }