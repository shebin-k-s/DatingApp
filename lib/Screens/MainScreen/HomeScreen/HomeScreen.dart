import 'package:datingapp/Screens/MainScreen/ScreenModel/ScreenModel.dart';
import 'package:datingapp/api/Url.dart';
import 'package:datingapp/api/data/profiles.dart';
import 'package:datingapp/api/models/search_profiles/profile.dart';
import 'package:datingapp/widgets/FilterBottomSheet.dart';
import 'package:datingapp/widgets/ProfileActionButton.dart';
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
  final ValueNotifier<List<String>> likedProfilesIdNotifier = ValueNotifier([]);
  final ValueNotifier<List<String>> favouriteProfilesIdNotifier =
      ValueNotifier([]);

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final profileDB = ProfileDB();
      if (location == null) {
        final SharedPreferences _sharedPref =
            await SharedPreferences.getInstance();
        final address = _sharedPref.getString('ADDRESS');
        location = address?.split(',').first;
        screens[0].subtitle!.value = location;
      }
      likedProfilesIdNotifier.value =
          await profileDB.getListFromSharedPreferences('LIKEDPROFILES');
      favouriteProfilesIdNotifier.value =
          await profileDB.getListFromSharedPreferences('FAVOURITEPROFILES');

      if (_profilesNotifier.value.isEmpty) {
        _fetchProfiles();
      }
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
            onRefresh: () async {
              hasNextPage = true;
              await _fetchProfiles(isRefresh: true);
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              itemCount: itemCount,
              itemBuilder: (context, index) {
                if (index < profiles.length) {
                  final profile = profiles[index];
                  final age =
                      calculateAge(profile.dateOfBirth ?? DateTime.now());
                  return ValueListenableBuilder(
                      valueListenable: favouriteProfilesIdNotifier,
                      builder: (context, favouriteProfilesId, child) {
                        return ValueListenableBuilder(
                          valueListenable: likedProfilesIdNotifier,
                          builder: (context, likedProfilesId, child) {
                            bool isLiked = likedProfilesId.contains(profile.id);
                            bool isFavourite =
                                favouriteProfilesId.contains(profile.id);
                            return ProfileCard(
                              id: profile.id ?? '',
                              name: profile.username ?? 'Username',
                              isLiked: isLiked,
                              isFavourite: isFavourite,
                              age: age,
                              address: profile.address ?? '',
                              imageUrl: profile.profilePic ??
                                  'https://pbs.twimg.com/media/FjU2lkcWYAgNG6d.jpg',
                              distance: profile.distanceInKm?.toString() ?? '',
                              onLikePress: () async {
                                bool status;
                                final profileDB = ProfileDB();
                                final likedIds =
                                    List<String>.from(likedProfilesId);
                                if (isLiked) {
                                  likedIds.remove(profile.id!);
                                  likedProfilesIdNotifier.value = likedIds;
                                  status = await profileDB
                                      .unlikeProfile(profile.id ?? '');
                                } else {
                                  likedIds.add(profile.id!);
                                  likedProfilesIdNotifier.value = likedIds;
                                  favouriteProfilesIdNotifier.value
                                      .remove(profile.id);
                                  status = await profileDB
                                      .likeProfile(profile.id ?? '');
                                }
                                if (status) {
                                  await profileDB.updateLikedProfiles(
                                      profile.id ?? '', !isLiked);
                                }
                              },
                              onFavouritePress: () async {
                                bool status;
                                final profileDB = ProfileDB();
                                final favouriteIds =
                                    List<String>.from(favouriteProfilesId);
                                if (isFavourite) {
                                  favouriteIds.remove(profile.id!);
                                  favouriteProfilesIdNotifier.value =
                                      favouriteIds;
                                  status = await profileDB
                                      .unfavoriteProfile(profile.id ?? '');
                                } else {
                                  favouriteIds.add(profile.id!);
                                  favouriteProfilesIdNotifier.value =
                                      favouriteIds;
                                  status = await profileDB
                                      .favoriteProfile(profile.id ?? '');
                                }
                                if (status) {
                                  await profileDB.updateFavoriteProfiles(
                                    profile.id ?? '',
                                    !isFavourite,
                                  );
                                }
                              },
                            );
                          },
                        );
                      });
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
                  fontWeight: FontWeight.bold),
            ),
          );
        }
      },
    );
  }

  Future<void> _fetchProfiles({isRefresh = false}) async {
    isLoading = true;
    if (hasNextPage) {
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
              gender == 'Any' ? null : gender,
              location,
              distance,
              currentPage,
              20,
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
              if (hasNextPage) {
                currentPage++;
              }
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
        await _fetchProfiles();
      }
    }
  }

  Future<void> handleFilter(BuildContext context) async {
    final filters = await FilterBottomSheet(
      context: context,
      interestedIn: gender ?? 'Any',
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
      hasNextPage = true;
      await _fetchProfiles(isRefresh: true);
    }
  }
}

class ProfileCard extends StatelessWidget {
  final String id;
  final String name;
  final int age;
  final String address;
  final String imageUrl;
  final String distance;
  final bool isLiked;
  final bool isFavourite;
  final VoidCallback onLikePress;
  final VoidCallback onFavouritePress;
  const ProfileCard({
    super.key,
    required this.name,
    required this.age,
    required this.address,
    required this.imageUrl,
    required this.distance,
    required this.isLiked,
    required this.isFavourite,
    required this.id,
    required this.onLikePress,
    required this.onFavouritePress,
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
        height: 450,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                '${Url().baseUrl}$imageUrl',
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Icon(Icons.error));
                },
              ),

              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$name, $age',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              address,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 18,
                              ),
                            ),
                            ProfileActionButton(
                              icon: isLiked
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isLiked ? Colors.red : Colors.white,
                              onPressed: onLikePress,
                            ),
                            ProfileActionButton(
                              icon:
                                  isFavourite ? Icons.star : Icons.star_border,
                              color: isFavourite ? Colors.amber : Colors.white,
                              onPressed: onFavouritePress,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Distance indicator
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
