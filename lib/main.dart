import 'package:datingapp/Screens/SplashScreen/SplashScreen.dart';
import 'package:flutter/material.dart';


const kColor = Color(0xffE94057);
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        splashFactory: NoSplash.splashFactory,
      ),
      home: Splashscreen(),
    );
  }
}
