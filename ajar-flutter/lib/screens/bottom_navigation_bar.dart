import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({super.key});

  @override
  State<BottomNavigationBarScreen> createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  int currentPageIndex = 0;

  // List of screens for the bottom navigation bar
  final List<Widget> pages = [
    // const HomeScreen(),
    // const FavoriteVehiclesScreen(),
    // const BookingScreen(),
    // const NotificationsScreen(),
    // const MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentPageIndex,
          type:
              BottomNavigationBarType.fixed, // This prevents shifting of icons
          selectedLabelStyle: const TextStyle(
            fontSize: 12, // Set the font size for the selected label
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 10, // Set the font size for the unselected label
          ),
          onTap: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
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
              icon: Badge(
                label: Text("5"),
                child: Icon(IconlyLight.notification),
              ),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(IconlyLight.moreSquare),
              label: 'More',
            ),
          ],
        ),
        body: pages[currentPageIndex], // Display the selected screen
      ),
    );
  }
}
