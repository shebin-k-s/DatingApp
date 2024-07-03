import 'package:datingapp/Screens/MainScreen/ScreenModel/ScreenModel.dart';
import 'package:datingapp/api/data/profiles.dart';
import 'package:datingapp/api/models/search_profiles/profile.dart';
import 'package:datingapp/widgets/FilterBottomSheet.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homescreen extends StatelessWidget {
  Homescreen({super.key});

  final ScrollController _scrollController = ScrollController();

  int currentPage = 1;
  bool hasNextPage = true;

  bool isLoading = true;
  String? location;
  int distance = 200;
  int? minAge;
  int? maxAge;
  String? gender;

  final ValueNotifier<List<Profile>> _profilesNotifier = ValueNotifier([]);

  Future<void> _fetchProfiles({isRefresh = false}) async {
    isLoading = true;
    try {
      if (isRefresh) {
        currentPage = 1;
        _profilesNotifier.value = [];
      }
      const maxRetries = 10;
      int retryCount = 0;
      bool retry = true;
      while (retry && retryCount < maxRetries) {
        retry = false;
        try {
          final result = await ProfileDB().searchProfiles(
            minAge,
            maxAge,
            gender,
            location,
            distance,
            currentPage,
            2,
          );
          if (result.profiles != null) {
            if (isRefresh) {
              _profilesNotifier.value = result.profiles!;
            } else {
              final profiles = List<Profile>.from(_profilesNotifier.value);
              profiles.addAll(result.profiles!);
              _profilesNotifier.value = profiles;
            }
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
    } finally {
      isLoading = false;
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
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!isLoading && hasNextPage) {
        print('object');
        await _fetchProfiles();
      }
    }
  }

  Future<void> handleFilter(BuildContext context) async {
    final filters = await FilterBottomSheet(
      context: context,
      interestedIn: gender ?? 'Male',
      distance: distance.toDouble(),
      ageRange:
          RangeValues(minAge?.toDouble() ?? 18, maxAge?.toDouble() ?? 100),
      location: location ?? '',
    );
    if (filters != null) {
      gender = filters['interestedIn'];
      final ageRange = filters['ageRange'];
      minAge = ageRange.start.toInt();
      maxAge = ageRange.end.toInt();
      location = filters['location'];
      distance = filters['distance'].toInt();

      screens[0].subtitle!.value = location;
      await _fetchProfiles(isRefresh: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final SharedPreferences _sharedPref =
          await SharedPreferences.getInstance();
      final address = _sharedPref.getString('ADDRESS');
      location = address?.split(',').first;
      screens[0].subtitle!.value = location;
      _fetchProfiles();
    });

    return ValueListenableBuilder<List<Profile>>(
      valueListenable: _profilesNotifier,
      builder: (context, profiles, child) {
        if (isLoading && profiles.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          );
        } else if (profiles.isNotEmpty) {
          int itemCount = hasNextPage ? profiles.length + 1 : profiles.length;
          return RefreshIndicator(
            onRefresh: () => _fetchProfiles(isRefresh: true),
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              itemCount: itemCount,
              itemBuilder: (context, index) {
                if (index < profiles.length) {
                  final profile = profiles[index];
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
                    ),
                  );
                }
              },
            ),
          );
        } else {
          return const Center(
            child: Text(
              'No Profiles found',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xffE94057),
                fontWeight: FontWeight.bold
              ),
            ),
          );
        }
      },
    );
  }
}

class ProfileCard extends StatelessWidget {
  final String name;
  final int age;
  final String address;
  final String imageUrl;
  final String distance;

  ProfileCard({
    super.key,
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
