import 'package:datingapp/Screens/AuthScreen/ValidationScreen.dart';
import 'package:datingapp/widgets/CustomBackbutton.dart';
import 'package:flutter/material.dart';

class Authscreen extends StatelessWidget {
  const Authscreen({
    super.key,
    required this.signup,
  });
  final bool signup;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomBackbutton(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 80,
                height: 80,
                child: Image.asset(
                  'assets/trademark.png',
                ),
              ),
              const SizedBox(height: 40),
              Text(
                signup ? 'Sign up to continue' : 'Sign in to continue',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => Validationscreen(
                        isPhone: false,
                        forLogin: !signup,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: const Color(0xffE94057),
                ),
                child: const Text(
                  'Continue with email',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => Validationscreen(
                        isPhone: true,
                        forLogin: !signup,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  'Use phone number',
                  style: TextStyle(
                    color: Color(0xffE94057),
                    fontSize: 16,
                  ),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text('Terms of use',
                        style: TextStyle(color: Color(0xffE94057))),
                  ),
                  const Text('•', style: TextStyle(color: Colors.grey)),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Privacy Policy',
                        style: TextStyle(color: Color(0xffE94057))),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
