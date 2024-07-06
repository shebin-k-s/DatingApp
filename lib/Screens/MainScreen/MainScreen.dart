import 'package:datingapp/Screens/MainScreen/ScreenModel/ScreenModel.dart';
import 'package:datingapp/widgets/BottomNavigation.dart';
import 'package:datingapp/widgets/CustomAppBar.dart';
import 'package:datingapp/widgets/TopSnackBarMessage.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final ValueNotifier<int> selectedBottomIndex = ValueNotifier(2);
  bool isFirstPress = true;

  Future<bool> handleBackPress(BuildContext context) async {
    if (isFirstPress) {
      isFirstPress = false;
      TopSnackBarMessage(
        context: context,
        message: 'Press back again to exit',
        type: ContentType.info,
      );
      Future.delayed(const Duration(seconds: 5), () {
        isFirstPress = true;
      });
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedBottomIndex,
      builder: (context, value, child) {
        final currentScreen = screens[value];
        return Scaffold(
          appBar: CustomAppBar(
            showBackButton: currentScreen.showBackButton ?? true,
            onBackPressed: () async {
              if (await handleBackPress(context)) {
                SystemNavigator.pop();
              }
            },
            actions: currentScreen.actions,
            centerTitle: currentScreen.centerTitle ?? true,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (currentScreen.title != null)
                  Text(
                    currentScreen.title!,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffE94057)),
                  ),
                if (currentScreen.subtitle != null)
                  ValueListenableBuilder<String?>(
                    valueListenable: currentScreen.subtitle!,
                    builder: (context, subtitle, child) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (subtitle != null && subtitle.isNotEmpty)
                              const Icon(
                                Icons.place,
                                size: 18,
                                color: Colors.black,
                              ),
                            if (subtitle != null && subtitle.isNotEmpty)
                              const SizedBox(width: 4),
                            Text(
                              subtitle ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigation(
            onItemTapped: (index) {
              return selectedBottomIndex.value = index;
            },
            selectedIndex: value,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DoubleBack(
              message: '',
              onFirstBackPress: handleBackPress,
              child: currentScreen.screen ?? Container(),
            ),
          ),
        );
      },
    );
  }
}
