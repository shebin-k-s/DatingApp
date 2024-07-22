import 'package:datingapp/Screens/MainScreen/MessageScreen/ChatScreen.dart';
import 'package:datingapp/api/Url.dart';
import 'package:datingapp/api/data/profiles.dart';
import 'package:datingapp/main.dart';
import 'package:datingapp/widgets/ActionButton.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({
    super.key,
    required this.username,
    required this.age,
    required this.location,
    required this.distance,
    required this.profilePic,
    required this.isLiked,
    required this.isFavourite,
    required this.id,
    required this.bio,
  });

  final String id;
  final String username;
  final int age;
  final String location;
  final String distance;
  final String profilePic;
  final bool isLiked;
  final bool isFavourite;
  final String bio;

  ValueNotifier<List<String>?> interestsNotifier = ValueNotifier([]);
  ValueNotifier<List<String>?> galleryImgUrlNotifier = ValueNotifier([]);
  List<String> myInterests = [];

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final profileDB = ProfileDB();
      if (myInterests.isEmpty) {
        myInterests = await profileDB.getListFromSharedPreferences('INTERESTS');
        print(myInterests);
      }

      final response = await ProfileDB().getProfiles(id);
      interestsNotifier.value = response.interests;
      galleryImgUrlNotifier.value = response.photos;
    });
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  '${Url().baseUrl}$profilePic',
                  fit: BoxFit.cover,
                  height: 500,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 500,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.person,
                        size: 100,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
                Positioned(
                  left: 20,
                  top: 40,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 50,
                      height: 50,
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.chevron_left,
                          color: Color(0xffE94057),
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.orange,
                            size: 32,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_outline,
                            color: Colors.red,
                            size: 32,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isFavourite ? Icons.star : Icons.star_border,
                            color: Colors.purple,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$username, $age',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Professional model',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      ActionButton(
                        onTap: (_) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => ChatScreen(
                                username: username,
                                profilePic: profilePic,
                                profileId: id,
                              ),
                            ),
                          );
                        },
                        iconPath: 'assets/send.svg',
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: Colors.red,
                        size: 26,
                      ),
                      Text(
                        distance,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        location,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'About',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    bio,
                    style: TextStyle(fontSize: 16),
                  ),
                  const Text('Read more', style: TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  const Text(
                    'Interests',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ValueListenableBuilder<List<String>?>(
                    valueListenable: interestsNotifier,
                    builder: (context, interests, child) {
                      if (interests == null) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (interests.isEmpty) {
                        return const Center(
                          child: Text(
                            "Nothing to Show",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      } else {
                        return Wrap(
                          spacing: 8,
                          children: interests.map((interest) {
                            bool isSame = myInterests.contains(interest);

                            return Chip(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                side: BorderSide(
                                  color: isSame ? kColor : Colors.grey,
                                ),
                              ),
                              label: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (isSame) ...{
                                      const Icon(
                                        Icons.done_all,
                                        color: kColor,
                                      ),
                                      const SizedBox(width: 4),
                                    },
                                    Text(
                                      interest,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: isSame ? kColor : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Gallery',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ValueListenableBuilder<List<String>?>(
                    valueListenable: galleryImgUrlNotifier,
                    builder: (context, galleryImages, child) {
                      print('here');
                      if (galleryImages == null) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (galleryImages.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              "Nothing to Show",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      } else {
                        return GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 3,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          children: galleryImages
                              .map(
                                (imageUrl) => Image.network(
                                  '${Url().baseUrl}$imageUrl',
                                  fit: BoxFit.cover,
                                ),
                              )
                              .toList(),
                        );
                      }
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
