import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String profileImage =
      "https://www.example.com/profile.jpg"; 
  final String name = "Rafey Waleed";
  final String username = "@rafeywaleed_a5";

  final List<String> friends = ["Alice", "Bob", "Charlie"];

  final List<Book> booksByUser = [
    Book(
      imgUrl:
          "https://m.media-amazon.com/images/I/71CKjYXMJrL._AC_UF1000,1000_QL80_.jpg",
      bookName: "The Kite Runner",
      author: "Khaled Hosseini",
      isbn: "9780747573395",
      type: 'e-book',
      rating: 5,
      review: "An emotional and impactful story about friendship and betrayal.",
    ),
    Book(
      imgUrl:
          "https://5.imimg.com/data5/SELLER/Default/2020/10/SI/BW/YL/43809805/screenshot-11-500x500.png",
      bookName: "The Alchemist",
      author: "Paulo Coelho",
      isbn: "9780008283643",
      type: 'e-book',
      rating: 4,
      review:
          "A journey of self-discovery with a spiritual and philosophical touch.",
    ),
  ];

  final List<Book> booksReadByUser = [
    Book(
      imgUrl:
          "https://m.media-amazon.com/images/I/81xIPfJ6iUL._AC_UF1000,1000_QL80_.jpg",
      bookName: "A Thousand Splendid Suns",
      author: "Khaled Hosseini",
      isbn: "9780747582977",
      type: 'print book',
      rating: 5,
      review:
          "A heartbreaking and beautifully written tale of two women in Afghanistan.",
    ),
    Book(
      imgUrl:
          "https://m.media-amazon.com/images/I/71YXYFviUmL._AC_UF1000,1000_QL80_.jpg",
      bookName: "The Complete Novels of Sherlock Holmes",
      author: "Arthur Conan Doyle",
      isbn: "9789355201225",
      type: 'e-book',
      rating: 4,
      review:
          "A collection of thrilling detective stories full of mystery and adventure.",
    ),
  ];

  final List<Book> favoriteBooks = [
    Book(
      imgUrl:
          "https://m.media-amazon.com/images/I/81xIPfJ6iUL._AC_UF1000,1000_QL80_.jpg",
      bookName: "A Thousand Splendid Suns",
      author: "Khaled Hosseini",
      isbn: "9780747582977",
      type: 'print book',
      rating: 5,
      review:
          "A heartbreaking and beautifully written tale of two women in Afghanistan.",
    ),
    Book(
      imgUrl:
          "https://5.imimg.com/data5/SELLER/Default/2020/10/SI/BW/YL/43809805/screenshot-11-500x500.png",
      bookName: "The Alchemist",
      author: "Paulo Coelho",
      isbn: "9780008283643",
      type: 'e-book',
      rating: 5,
      review:
          "A journey of self-discovery with a spiritual and philosophical touch.",
    ),
  ];

  // Flags to control horizontal or vertical layout
  bool isHorizontalBooksByUser = true;
  bool isHorizontalBooksReadByUser = true;
  bool isHorizontalFavoriteBooks = true;

  // Function to toggle layout (horizontal/vertical) for a specific list
  void toggleLayout(String listType) {
    setState(() {
      if (listType == "BooksByUser") {
        isHorizontalBooksByUser = !isHorizontalBooksByUser;
      } else if (listType == "BooksReadByUser") {
        isHorizontalBooksReadByUser = !isHorizontalBooksReadByUser;
      } else if (listType == "FavoriteBooks") {
        isHorizontalFavoriteBooks = !isHorizontalFavoriteBooks;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Profile Section
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    border: Border.all(color: Colors.teal, width: 4),
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(profileImage),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[700],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  username,
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 20),
                // Friends Count Section
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.teal[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.people, color: Colors.teal, size: 24),
                      SizedBox(width: 8),
                      Text(
                        "${friends.length} Friends",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Books Sections
                SectionTitle(
                  title: "Books by $username",
                  isHorizontal: isHorizontalBooksByUser,
                  onTap: () => toggleLayout("BooksByUser"),
                ),
                isHorizontalBooksByUser
                    ? HorizontalBookList(books: booksByUser)
                    : VerticalBookList(books: booksByUser),
                SizedBox(height: 20),
                SectionTitle(
                  title: "Books read by $username",
                  isHorizontal: isHorizontalBooksReadByUser,
                  onTap: () => toggleLayout("BooksReadByUser"),
                ),
                isHorizontalBooksReadByUser
                    ? HorizontalBookList(books: booksReadByUser)
                    : VerticalBookList(books: booksReadByUser),
                SizedBox(height: 20),
                SectionTitle(
                  title: "Favorite Books",
                  isHorizontal: isHorizontalFavoriteBooks,
                  onTap: () => toggleLayout("FavoriteBooks"),
                ),
                isHorizontalFavoriteBooks
                    ? HorizontalBookList(books: favoriteBooks)
                    : VerticalBookList(books: favoriteBooks),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Book {
  final String bookName;
  final String author;
  final String imgUrl;
  final String isbn;
  final String type; // 'e-book' or 'print book'
  final int rating; // User rating (1-5)
  final String review; // User review

  Book({
    required this.bookName,
    required this.author,
    required this.imgUrl,
    required this.isbn,
    required this.type,
    required this.rating,
    required this.review,
  });
}

class SectionTitle extends StatelessWidget {
  final String title;
  final bool isHorizontal;
  final VoidCallback onTap;

  SectionTitle(
      {required this.title, required this.isHorizontal, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          Icon(
            isHorizontal ? Icons.arrow_forward_ios : Icons.arrow_drop_down,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}

class HorizontalBookList extends StatelessWidget {
  final List<Book> books;

  HorizontalBookList({required this.books});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        itemBuilder: (context, index) {
          Book book = books[index];
          return Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    book.imgUrl,
                    width: 100,
                    height: 140,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  width: 100,
                  child: Text(
                    book.bookName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class VerticalBookList extends StatelessWidget {
  final List<Book> books;

  VerticalBookList({required this.books});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: books.length,
      itemBuilder: (context, index) {
        Book book = books[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    book.imgUrl,
                    width: 80,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.bookName,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "by ${book.author}",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: List.generate(
                          book.rating,
                          (index) =>
                              Icon(Icons.star, color: Colors.yellow, size: 18),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        book.review,
                        style: TextStyle(color: Colors.grey[700], fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
