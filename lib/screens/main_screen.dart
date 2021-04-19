import 'package:flutter/material.dart';
import 'package:kdofavoris/screens/explorer_screen.dart';
import 'package:kdofavoris/screens/home_screen.dart';

class MainScreen extends StatefulWidget {
  static const String ROUTE = "/";

  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          HomeScreen(),
          ExplorerScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: (index) {
          setState(() => _currentPageIndex = index);

          _pageController.animateToPage(
            _currentPageIndex,
            duration: Duration(
              milliseconds: 300,
            ),
            curve: Curves.easeIn,
          );
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Explorer',
            backgroundColor: Colors.green,
          ),
        ],
      ),
    );
  }
}
