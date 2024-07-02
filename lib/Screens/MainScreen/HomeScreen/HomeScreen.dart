import 'package:datingapp/api/data/profiles.dart';
import 'package:datingapp/api/models/search_profiles/profile.dart';
import 'package:datingapp/api/models/search_profiles/search_profiles.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homescreen extends StatelessWidget {
  ScrollController _scrollController = ScrollController();

  int currentPage = 1;
  bool hasNextPage = true;

  ValueNotifier<List<Profile>> _profilesNotifier = ValueNotifier([]);
  bool isLoading = false;

  Future<void> _fetchProfiles() async {
    try {
      final SharedPreferences _sharedPref =
          await SharedPreferences.getInstance();
      final address = _sharedPref.getString('ADDRESS');

      const maxRetries = 10;
      int retryCount = 0;
      bool retry = true;
      while (retry && retryCount < maxRetries) {
        retry = false;
        try {
          final result = await ProfileDB().searchProfiles(
            null,
            null,
            null,
            address,
            1000,
            currentPage,
            20,
          );

          if (result.profiles != null) {
            print('length ${result.profiles!.length}');
            final profiles = List<Profile>.from(_profilesNotifier.value);
            profiles.addAll(result.profiles!);
            _profilesNotifier.value = profiles;
          }
          if (result.hasNextPage != null) {
            hasNextPage = result.hasNextPage!;
            currentPage++;
          }
        } catch (e) {
          print('Error fetching profiles: $e');
          retry = true;
          retryCount++;
          await Future.delayed(Duration(seconds: retryCount));
        }
      }
    } catch (e) {
      print('Error fetching profiles: $e');
    }
  }

  int calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  void _onScroll() async {
    print('nex ${hasNextPage}');
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      print(isLoading);
      print('hkjjere');
      print(hasNextPage);
      if (!isLoading && hasNextPage) {
        isLoading = true;
        await _fetchProfiles();
        isLoading = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchProfiles());
    return ValueListenableBuilder(
        valueListenable: _profilesNotifier,
        builder: (context, value, child) {
          if (value.isNotEmpty) {
            int itemCount = hasNextPage ? value.length + 1 : value.length;
            return ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              itemCount: itemCount,
              itemBuilder: (context, index) {
                if (index < value.length) {
                  final profile = value[index];
                  final age =
                      calculateAge(profile.dateOfBirth ?? DateTime.now());

                  return ProfileCard(
                    name: profile.username ?? 'Username',
                    age: age,
                    address: profile.address ?? '',
                    imageUrl: profile.profilePic ??
                        'https://pbs.twimg.com/media/FjU2lkcWYAgNG6d.jpg',
                    distance: profile.distanceInKm?.toString() ?? '',
                  );
                } else {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Colors.red,
                  ));
                }
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            );
          }
        });
  }
}

class ProfileCard extends StatelessWidget {
  final String name;
  final int age;
  final String address;
  final String imageUrl;
  final String distance;

  ProfileCard({
    required this.name,
    required this.age,
    required this.address,
    required this.imageUrl,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final localPosition = box.globalToLocal(details.globalPosition);
        if (localPosition.dy < box.size.height * 0.6) {
          print('here');
        }
      },
      onDoubleTap: () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              Image.network(
                imageUrl,
                height: 450,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 20,
                bottom: 20,
                right: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$name, $age',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            address,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                            size: 32,
                          ),
                          onPressed: () {
                            print('like');
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.star_border,
                            color: Colors.white,
                            size: 32,
                          ),
                          onPressed: () {
                            print('favourite');
                            // Add favourite functionality here
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 20,
                top: 20,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.location_on,
                          color: Colors.pink, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        distance,
                        style: const TextStyle(
                          color: Colors.pink,
                          fontWeight: FontWeight.bold,
                        ),
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
}
