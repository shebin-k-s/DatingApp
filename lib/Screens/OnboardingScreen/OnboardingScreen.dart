import 'package:carousel_slider/carousel_slider.dart';
import 'package:datingapp/Screens/AuthScreen/AuthScreen.dart';
import 'package:flutter/material.dart';

class Onboardingscreen extends StatelessWidget {
  Onboardingscreen({super.key});

  final List<Map<String, String>> slideList = [
    {
      'image': 'assets/girl1.png',
      'heading': 'Algorithm',
      'description':
          'Users going through a vetting process to ensure you never match with bots.',
    },
    {
      'image': 'assets/girl2.png',
      'heading': 'Matches',
      'description':
          'We use your preferences to find the best potential matches for you.',
    },
    {
      'image': 'assets/girl3.png',
      'heading': 'Premium',
      'description':
          'Unlock additional features with our premium subscription.',
    },
  ];

  final ValueNotifier<int> scrollIndexNotifier = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            children: [
              CarouselSlider(
                items: slideList
                    .map(
                      (val) => Image.asset(
                        val['image']!,
                        fit: BoxFit.contain,
                      ),
                    )
                    .toList(),
                options: CarouselOptions(
                  height: 400,
                  viewportFraction: 0.6,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    scrollIndexNotifier.value = index;
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      ValueListenableBuilder(
                        valueListenable: scrollIndexNotifier,
                        builder: (context, value, child) {
                          return Column(
                            children: [
                              const SizedBox(height: 20),
                              Text(
                                slideList[value]['heading']!,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                slideList[value]['description']!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 14),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  slideList.length,
                                  (index) => Container(
                                    width: 10,
                                    height: 10,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: value == index
                                          ? const Color(0xffE94057)
                                          : Colors.grey.shade300,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              backgroundColor: const Color(0xffE94057),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => const Authscreen(
                                    signup: true,
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              'Create an account',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) =>
                                      const Authscreen(signup: false),
                                ),
                              );
                            },
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                color: Color(0xffE94057),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showMessage(BuildContext context, String message, bool isError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? const Color(0xffE94057) : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
