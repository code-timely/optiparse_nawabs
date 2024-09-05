import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For HapticFeedback
import 'package:optiparse_nawabs/screens/analysispage.dart';
import 'package:optiparse_nawabs/screens/homepage.dart';
import 'package:optiparse_nawabs/screens/profilepage.dart';
import 'package:optiparse_nawabs/screens/searchpage.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;

  const BottomNavBar({super.key,required this.currentIndex});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();

}

class _BottomNavBarState extends State<BottomNavBar> {
  void _onItemTapped(int index) {
    if (index == widget.currentIndex) {
      return;
    }
    // Trigger vibration when icon is tapped
    HapticFeedback.lightImpact();

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SearchPage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AnalysisPage()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
        break;
    }
  }


@override
Widget build(BuildContext context) {
  return BottomAppBar(
    shape: const CircularNotchedRectangle(),
    notchMargin: 10.0,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildNavItem(icon: Icons.home, index: 0),
        _buildNavItem(icon: Icons.search, index: 1),
        const SizedBox(width: 5), // Space for the floating action button
        _buildNavItem(icon: Icons.analytics, index: 2),
        _buildNavItem(icon: Icons.person, index: 3),
      ],
    ),
  );
}


  Widget _buildNavItem({required IconData icon, required int index}) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 20),
        color: Colors.transparent,
        child: Icon(
          icon,
          color: widget.currentIndex == index ? Colors.blue : Colors.grey,
        ),
      ),
    );
  }
}

