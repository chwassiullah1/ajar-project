import 'package:ajar/screens/booking_screens/bookings_screen.dart';
import 'package:ajar/screens/home_screen/home_screen.dart';
import 'package:ajar/screens/chatting_and_notifications/conversations_and_notificatiosns_screen.dart';
import 'package:flutter/material.dart';
import 'package:ajar/screens/favorites_screen/favorites_screen.dart';
import 'package:ajar/screens/more_screens/more_screen.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({super.key});

  @override
  State<BottomNavigationBarScreen> createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  int currentPageIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentPageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // List of screens for the bottom navigation bar
  final List<Widget> pages = [
    const HomeScreen(),
    const FavoriteVehiclesScreen(),
    const BookingScreen(),
    const ConverationsScreen(),
    const MoreScreen(),
  ];

  void onPageChanged(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  void onBottomNavTapped(int index) {
    setState(() {
      currentPageIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300), // Set animation duration
        curve: Curves.easeInOut, // Set animation curve
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPageIndex,
        type: BottomNavigationBarType.fixed, // Prevents icon shifting
        selectedLabelStyle: const TextStyle(
          fontSize: 12, // Set the font size for the selected label
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 10, // Set the font size for the unselected label
        ),
        onTap: onBottomNavTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.heart),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.send),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.message),
            label: 'Inbox',
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.moreSquare),
            label: 'More',
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: onPageChanged,
        physics:
            const NeverScrollableScrollPhysics(),
        children: pages, // Disable swipe if needed
      ),
    );
  }
}
