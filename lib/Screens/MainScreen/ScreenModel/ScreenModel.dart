import 'package:datingapp/Screens/MainScreen/HomeScreen/HomeScreen.dart';
import 'package:datingapp/widgets/ActionButton.dart';
import 'package:flutter/material.dart';

class ScreenModel {
  final Widget? screen;
  final String? title;
  final ValueNotifier<String?>? subtitle;
  final List<Widget>? actions;
  final bool? showBackButton;
  final bool? centerTitle;

  ScreenModel({
    this.screen,
    this.title,
    this.centerTitle,
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
    actions: [
      ActionButton(
        onTap: () {},
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
