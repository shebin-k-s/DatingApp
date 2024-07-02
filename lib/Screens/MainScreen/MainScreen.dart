import 'package:datingapp/Screens/MainScreen/HomeScreen/HomeScreen.dart';
import 'package:datingapp/widgets/BottomNavigation.dart';
import 'package:datingapp/widgets/CustomAppBar.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final _screens = [
    Homescreen(),
    Homescreen(),
    Homescreen(),
    Homescreen(),
  ];
  final ValueNotifier<int> selectedBottomIndex = ValueNotifier(0);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedBottomIndex,
      builder: (context, value, child) {
        return Scaffold(
          appBar: const CustomAppBar(),
          bottomNavigationBar: BottomNavigation(
            onItemTapped: (index) {
              return selectedBottomIndex.value = index;
            },
            selectedIndex: value,
          ),
          body: DoubleBack(
            textStyle: TextStyle(color: Colors.red),
            child: _screens[value],
          ),
        );
      },
    );
  }
}
