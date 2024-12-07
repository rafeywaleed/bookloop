import 'package:flutter/material.dart';

class ChatSettingsScreen extends StatefulWidget {
  @override
  _ChatSettingsScreenState createState() => _ChatSettingsScreenState();
}

class _ChatSettingsScreenState extends State<ChatSettingsScreen> {
  // Initially set the theme to 'Galaxy'
  String selectedTheme = 'Galaxy';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text('Chat Settings', style: TextStyle(fontFamily: 'Georgia', fontSize: 20)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Friend Profile Section
            ListTile(
              contentPadding: EdgeInsets.all(10),
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/images/friend.jpg'), // Replace with your image
              ),
              title: Text('Friend Name', style: TextStyle(fontSize: 20, fontFamily: 'Georgia', fontWeight: FontWeight.bold)),
              subtitle: Text('Online', style: TextStyle(color: Colors.green[600], fontFamily: 'Georgia')),
            ),
            Divider(),

            // Chat Theme Section
            Text(
              'Select Chat Theme',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Georgia'),
            ),
            Divider(),
            Column(
              children: ['Grid', 'Galaxy', 'Butterfly', 'Neon'].map((theme) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    color: selectedTheme == theme ? Colors.brown[100] : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selectedTheme == theme ? Colors.brown : Colors.grey[300]!,
                      width: 2,
                    ),
                  ),
                  child: ListTile(
                    title: Text(theme, style: TextStyle(fontFamily: 'Georgia', fontWeight: FontWeight.w500)),
                    trailing: selectedTheme == theme
                        ? Icon(Icons.check_circle, color: Colors.brown, size: 24)
                        : null,
                    onTap: () {
                      setState(() {
                        selectedTheme = theme; // Update selected theme
                      });
                    },
                  ),
                );
              }).toList(),
            ),
            Divider(),

            // Block User Option
            ListTile(
              title: Text('Block User', style: TextStyle(fontFamily: 'Georgia', color: Colors.red)),
              onTap: () {
                // Simulating the action of blocking the user
                _showBlockDialog(context);
              },
              trailing: Icon(Icons.block, color: Colors.red),
            ),

            // Books in Common Section
            SizedBox(height: 20),
            Text(
              'Books in Common',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Georgia'),
            ),
            SizedBox(height: 10),
            Container(
              height: 220, // Adjust the height of the book card container
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  BookCard(
                    imgUrl: "https://m.media-amazon.com/images/I/71CKjYXMJrL._AC_UF1000,1000_QL80_.jpg",
                    bookName: "The Kite Runner",
                  ),
                  BookCard(
                    imgUrl: "https://5.imimg.com/data5/SELLER/Default/2020/10/SI/BW/YL/43809805/screenshot-11-500x500.png",
                    bookName: "The Alchemist",
                  ),
                  BookCard(
                    imgUrl: "https://m.media-amazon.com/images/I/81xIPfJ6iUL._AC_UF1000,1000_QL80_.jpg",
                    bookName: "A Thousand Splendid Suns",
                  ),
                  BookCard(
                    imgUrl: "https://m.media-amazon.com/images/I/71YXYFviUmL._AC_UF1000,1000_QL80_.jpg",
                    bookName: "The Complete Novels of Sherlock Holmes",
                  ),
                ],
              ),
            ),
            Divider(),

            // Date Became Friends Section (Positioned at the bottom center)
            Spacer(), // This ensures the date section is pushed to the bottom
            Center(
              child: ListTile(
                title: Text('Date Became Friends', style: TextStyle(fontFamily: 'Georgia')),
                subtitle: Text('January 5, 2022', style: TextStyle(fontFamily: 'Georgia')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to show block user confirmation dialog (dummy implementation)
  void _showBlockDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Block User', style: TextStyle(fontFamily: 'Georgia')),
          content: Text('Are you sure you want to block this user?', style: TextStyle(fontFamily: 'Georgia')),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel', style: TextStyle(fontFamily: 'Georgia')),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                // Simulate blocking the user
                print('User blocked');
              },
              child: Text('Block', style: TextStyle(fontFamily: 'Georgia', color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}


class BookCard extends StatelessWidget {
  final String imgUrl;
  final String bookName;

  const BookCard({required this.imgUrl, required this.bookName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120, // Fixed width for uniform card size
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imgUrl,
                height: 160, // Fixed height for uniformity
                width: double.infinity,
                fit: BoxFit.cover, // Ensures the image fills the container
              ),
            ),
            SizedBox(height: 8),
            // Book name with two-line truncation
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                bookName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis, // Truncate text if more than 2 lines
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.2, // Adjust line height for better readability
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
