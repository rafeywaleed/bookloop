import 'package:flutter/material.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown, 
        title: Text('Chats & Communities', style: TextStyle(fontFamily: 'Georgia', fontWeight: FontWeight.bold,color: Colors.white)),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Chats'),
            Tab(text: 'Communities'),
          ],
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Chats Tab
          ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return ChatCard(index: index);
            },
          ),
          // Communities Tab
          ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return CommunityCard(index: index);
            },
          ),
        ],
      ),
    );
  }
}

class ChatCard extends StatelessWidget {
  final int index;
  const ChatCard({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      color: Colors.brown[50],
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.brown, 
          child: Text('C${index + 1}', style: TextStyle(color: Colors.white, fontFamily: 'Georgia')),
        ),
        title: Text(
          'Chat with Person ${index + 1}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Georgia'),
        ),
        subtitle: Text('This is a sample message for chat ${index + 1}.', style: TextStyle(fontFamily: 'Georgia')),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.brown),
      ),
    );
  }
}

class CommunityCard extends StatelessWidget {
  final int index;
  const CommunityCard({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      color: Colors.green[50], 
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.green, // Green to match community theme
          child: Text('G${index + 1}', style: TextStyle(color: Colors.white, fontFamily: 'Georgia')),
        ),
        title: Text(
          'Community ${index + 1}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Georgia'),
        ),
        subtitle: Text('This is a sample description for community ${index + 1}.', style: TextStyle(fontFamily: 'Georgia')),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.green),
      ),
    );
  }
}
