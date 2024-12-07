import 'package:bookloop/gBook_lib/presentation/screens/gLib_categories.dart';
import 'package:flutter/material.dart';

import '../../app/constants/constants.dart';
import 'glib_home.dart';

class GLibScreen extends StatefulWidget {
  const GLibScreen({Key? key}) : super(key: key);

  @override
  State<GLibScreen> createState() => _GLibScreenState();
}

class _GLibScreenState extends State<GLibScreen> {
  int _currentIndex = 0;
  final screens = const [
    GLibHome(),
    GLibCategories(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.black,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontSize: 15),
        unselectedLabelStyle: const TextStyle(fontSize: 13),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
