import 'package:datingapp/Screens/MainScreen/HomeScreen/HomeScreen.dart';
import 'package:datingapp/widgets/ActionButton.dart';
import 'package:datingapp/widgets/FilterBottomSheet.dart';
import 'package:flutter/material.dart';

class ScreenModel {
  final dynamic screen;
  final String? title;
  final ValueNotifier<String?>? subtitle;
  final List<Widget>? actions;
  final bool? showBackButton;
  final bool? centerTitle;
  BuildContext? context;

  ScreenModel({
    this.screen,
    this.title,
    this.centerTitle,
    this.context,
    String? initialSubtitle,
    this.actions,
    this.showBackButton,
  }) : subtitle =
            initialSubtitle != null ? ValueNotifier(initialSubtitle) : null;
}

final List<ScreenModel> screens = [
  ScreenModel(
    screen: Homescreen(),
    title: 'Discover',
    initialSubtitle: '',
    actions: [
      ActionButton(
        onTap: (context) {
          if (screens.isNotEmpty) {
            screens[0].screen!.handleFilter(context);
          }
        },
        iconPath: 'assets/filter.svg',
      ),
    ],
  ),
  ScreenModel(
    screen: Homescreen(),
    title: 'Matches',
    actions: [
      ActionButton(
        onTap: () {},
        iconPath: 'assets/match.svg',
      ),
    ],
  ),
  ScreenModel(
    screen: Homescreen(),
    title: 'Messages',
    actions: [
      ActionButton(
        onTap: () {},
        iconPath: 'assets/filter.svg',
      ),
    ],
  ),
  ScreenModel(
    screen: Homescreen(),
    title: 'Profile',
  ),
];
