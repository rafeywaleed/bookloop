  import 'package:flutter/material.dart';

  class CommunitySettingScreen extends StatefulWidget {
    @override
    _CommunitySettingScreenState createState() => _CommunitySettingScreenState();
  }

  class _CommunitySettingScreenState extends State<CommunitySettingScreen> {
    // Initially set the theme to 'Galaxy'
    String selectedTheme = 'Galaxy';

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown,
          title: Text('Community Settings', style: TextStyle(fontFamily: 'Georgia', fontSize: 22)),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              // Community Profile Section
              _buildCommunityProfile(),
              SizedBox(height: 20),

              // Chat Theme Section
              _buildThemeSelector(),
              SizedBox(height: 20),

              // Leave and Mute Community Options
              _buildLeaveMuteOptions(),
              SizedBox(height: 20),

              // People in Community Section
              _buildPeopleInCommunity(),
              SizedBox(height: 20),

              // Friends in Community Section
              _buildFriendsList(),
              SizedBox(height: 20),

              // Date User Joined Community Section
              _buildDateJoined(),
            ],
          ),
        ),
      );
    }

    // Community Profile Section
    Widget _buildCommunityProfile() {
      return Container(
        padding: EdgeInsets.all(20),
        height: 250, // Extended height to make it longer
        decoration: BoxDecoration(
          color: Colors.brown[50],
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(color: Colors.grey.shade300, blurRadius: 10, offset: Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/community.jpg'), // Replace with your image
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Community Name',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5),
                      // Description with fixed length
                      Text(
                        'This is a short description about the community. The community brings like-minded people together to discuss books and share their reading experiences.                                          ', // Adding space to make it 100 characters long
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        maxLines: 2, // Limit description to 2 lines
                        overflow: TextOverflow.ellipsis, // Ensure text truncates if it's too long
                      ),
                    ],
                  ),
                ),
          ],
        ),
      );
    }

    // Theme Selector Section
    Widget _buildThemeSelector() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select Chat Theme', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
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
                  title: Text(theme, style: TextStyle(fontWeight: FontWeight.w500)),
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
        ],
      );
    }

    // Leave and Mute Community Options
    Widget _buildLeaveMuteOptions() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Community Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              _showLeaveCommunityDialog(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red, width: 2),
              ),
              child: Row(
                children: [
                  Icon(Icons.exit_to_app, color: Colors.red),
                  SizedBox(width: 10),
                  Text('Leave Community', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              _showMuteCommunityDialog(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey, width: 2),
              ),
              child: Row(
                children: [
                  Icon(Icons.volume_off, color: Colors.grey),
                  SizedBox(width: 10),
                  Text('Mute Community', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      );
    }

    // People in Community Section
    Widget _buildPeopleInCommunity() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('People in Community', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text('500+ people', style: TextStyle(fontSize: 16)),
        ],
      );
    }

    // Friends List in Community Section
    Widget _buildFriendsList() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Friends in Community', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Column(
            children: [
              _buildFriendCard('Karan', 'assets/images/karan.jpg'),
              _buildFriendCard('Arjun', 'assets/images/arjun.jpg'),
            ],
          ),
        ],
      );
    }

    // Friend Card Widget
    Widget _buildFriendCard(String name, String imagePath) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.grey.shade300, blurRadius: 5, offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage(imagePath),
            ),
            SizedBox(width: 10),
            Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      );
    }

    // Date Joined Section
    Widget _buildDateJoined() {
      return Center(
        child: Text(
          'Joined on January 5, 2023',
          style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
        ),
      );
    }

    // Function to show leave community confirmation dialog (dummy implementation)
    void _showLeaveCommunityDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Leave Community', style: TextStyle(fontFamily: 'Georgia')),
            content: Text('Are you sure you want to leave this community?', style: TextStyle(fontFamily: 'Georgia')),
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
                  // Simulate leaving the community
                  print('User left the community');
                },
                child: Text('Leave', style: TextStyle(fontFamily: 'Georgia', color: Colors.red)),
              ),
            ],
          );
        },
      );
    }

    // Function to show mute community confirmation dialog (dummy implementation)
    void _showMuteCommunityDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Mute Community', style: TextStyle(fontFamily: 'Georgia')),
            content: Text('Are you sure you want to mute notifications from this community?', style: TextStyle(fontFamily: 'Georgia')),
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
                  // Simulate muting the community
                  print('Community notifications muted');
                },
                child: Text('Mute', style: TextStyle(fontFamily: 'Georgia', color: Colors.grey)),
              ),
            ],
          );
        },
      );
    }
  }
