import 'package:datingapp/Screens/OnboardingScreen/OnboardingScreen.dart';
import 'package:datingapp/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profilescreen extends StatelessWidget {
  const Profilescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          final _sharedPref = await SharedPreferences.getInstance();
          _sharedPref.clear();
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (ctx) => Onboardingscreen()), (route) => false);
        },
        child: const Text(
          "Logout",
          style: TextStyle(
              color: kColor, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
