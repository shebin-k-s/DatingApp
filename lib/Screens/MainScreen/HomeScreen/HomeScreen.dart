import 'package:flutter/material.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Text(
          'Home',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
