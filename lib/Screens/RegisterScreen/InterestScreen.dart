import 'package:datingapp/Screens/MainScreen/MainScreen.dart';
import 'package:datingapp/api/data/Auth.dart';
import 'package:datingapp/api/models/user_model/user_model.dart';
import 'package:datingapp/widgets/ApiResponseUtil.dart';
import 'package:datingapp/widgets/CustomAppBar.dart';
import 'package:datingapp/widgets/TopSnackBarMessage.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class InterestScreen extends StatelessWidget {
  List<String> interests = [
    'Photography',
    'Shopping',
    'Karaoke',
    'Yoga',
    'Cooking',
    'Tennis',
    'Run',
    'Swimming',
    'Art',
    'Traveling',
    'Extreme',
    'Music',
    'Drink',
    'Video games'
  ];

  final ValueNotifier<List<String>> selectedInterestsNotifier =
      ValueNotifier([]);

  final ValueNotifier<bool> isLoadingNotifier = ValueNotifier(false);

  final UserModel user;

  InterestScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: 40,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your interests',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Select a few of your interests and let everyone know what you\'re passionate about.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: selectedInterestsNotifier,
                  builder: (context, value, child) {
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 14,
                      ),
                      itemCount: interests.length,
                      itemBuilder: (context, index) {
                        String interest = interests[index];
                        bool isSelected = value.contains(interest);
                        return Theme(
                          data: ThemeData(
                            splashFactory: NoSplash.splashFactory,
                          ),
                          child: ChoiceChip(
                            showCheckmark: false,
                            elevation: 8,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            shadowColor: Colors.black,
                            disabledColor: Colors.transparent,
                            label: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Container(
                                width: double.infinity,
                                height: 40,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      getIconForInterest(interest),
                                      size: 20,
                                      color: isSelected
                                          ? Colors.white
                                          : const Color(0xffE94057),
                                    ),
                                    const SizedBox(width: 5),
                                    Flexible(
                                      child: Text(
                                        interest,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            selected: isSelected,
                            onSelected: (selected) {
                              List<String> currentList = List.from(value);
                              if (selected) {
                                currentList.add(interest);
                              } else {
                                currentList.remove(interest);
                              }
                              selectedInterestsNotifier.value = currentList;
                            },
                            backgroundColor: Colors.white,
                            selectedColor: const Color(0xffE94057),
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: isSelected
                                    ? const Color(0xffE94057)
                                    : Colors.transparent,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffE94057),
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: () async {
                  if (isLoadingNotifier.value == false) {
                    if (selectedInterestsNotifier.value.length < 3) {
                      TopSnackBarMessage(
                        context: context,
                        message: 'Select Atleast 3 items',
                        type: ContentType.info,
                      );
                    } else {
                      user.interests = selectedInterestsNotifier.value;
                      print(user.interests);
                      isLoadingNotifier.value = true;

                      final response = await AuthDB().registerUser(user);

                      ApiResponseUtil(
                        context: context,
                        response: response,
                        constantErrorMessage: 'Failed to Register',
                        onSuccess: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (ctx) => MainScreen(),
                            ),
                            (route) => false,
                          );
                        },
                      );
                      isLoadingNotifier.value = false;
                    }
                  }
                },
                child: ValueListenableBuilder(
                  valueListenable: isLoadingNotifier,
                  builder: (context, value, child) {
                    if (value) {
                      return const CircularProgressIndicator(
                        color: Colors.white,
                      );
                    } else {
                      return const Text('Register');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData getIconForInterest(String interest) {
    switch (interest) {
      case 'Photography':
        return Icons.camera_alt;
      case 'Shopping':
        return Icons.shopping_bag;
      case 'Karaoke':
        return Icons.mic;
      case 'Yoga':
        return Icons.self_improvement;
      case 'Cooking':
        return Icons.restaurant;
      case 'Tennis':
        return Icons.sports_tennis;
      case 'Run':
        return Icons.directions_run;
      case 'Swimming':
        return Icons.pool;
      case 'Art':
        return Icons.palette;
      case 'Traveling':
        return Icons.airplanemode_active;
      case 'Extreme':
        return Icons.paragliding;
      case 'Music':
        return Icons.music_note;
      case 'Drink':
        return Icons.local_bar;
      case 'Video games':
        return Icons.videogame_asset;
      default:
        return Icons.star;
    }
  }
}
