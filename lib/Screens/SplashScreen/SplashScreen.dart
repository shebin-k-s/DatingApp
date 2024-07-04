import 'package:datingapp/Screens/MainScreen/MainScreen.dart';
import 'package:datingapp/Screens/OnboardingScreen/OnboardingScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    isUserLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Text(
        'CONNECT ME',
        style: TextStyle(
            color: Color(0xffE94057),
            fontSize: 32,
            fontWeight: FontWeight.bold),
      )),
    );
  }

  void isUserLogin() async {
    final _sharedPref = await SharedPreferences.getInstance();
    final _token = await _sharedPref.getString('TOKEN');

    await Future.delayed(const Duration(milliseconds: 3000));
    print(_token);

    if (_token != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => MainScreen(),
        ),

      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => Onboardingscreen(),
        ),
      );
    }
  }
}
