import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final Function(int) onItemTapped;
  final int selectedIndex;

  const BottomNavigation({
    super.key,
    required this.onItemTapped,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Add padding here
      decoration: BoxDecoration(
        color: const Color(0xfff3f3f3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        selectedIconTheme: const IconThemeData(
          color: Color(0xffe94057),
        ),
        unselectedIconTheme: const IconThemeData(
          color: Color.fromARGB(255, 111, 112, 117),
        ),
        selectedItemColor: const Color(0xffe94057),
        unselectedItemColor: const Color.fromARGB(255, 111, 112, 117),
        currentIndex: selectedIndex,
        iconSize: 28,
        selectedFontSize: 16,
        unselectedFontSize: 14,
       
        onTap: (value) => onItemTapped(value),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(selectedIndex == 0 ? Icons.style : Icons.style_outlined),
          ),
          BottomNavigationBarItem(
            label: 'Match',
            icon: Icon(
                selectedIndex == 1 ? Icons.favorite : Icons.favorite_border),
          ),
          BottomNavigationBarItem(
            label: 'Message',
            icon: Icon(
                selectedIndex == 2 ? Icons.chat : Icons.chat_bubble_outline),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon:
                Icon(selectedIndex == 3 ? Icons.person : Icons.person_outline),
          ),
        ],
      ),
    );
  }
}
