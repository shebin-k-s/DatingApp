import 'package:datingapp/Screens/OnboardingScreen/OnboardingScreen.dart';
import 'package:datingapp/Screens/RegisterScreen/InterestScreen.dart';
import 'package:datingapp/Screens/RegisterScreen/ProfileRegisterScreen.dart';
import 'package:datingapp/api/models/user_model/user_model.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: Onboardingscreen(),
      // home: InterestScreen(user: UserModel(),),
      // home: ProfileRegisterScreen(),
    );
  }
}
