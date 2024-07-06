import 'dart:ui';

import 'package:datingapp/api/Url.dart';
import 'package:datingapp/api/data/profiles.dart';
import 'package:datingapp/api/models/profiles_liked_me/profile.dart';
import 'package:datingapp/api/models/profiles_liked_me/profiles_liked_me.dart';
import 'package:datingapp/main.dart';
import 'package:datingapp/utils/calculateAge.dart';
import 'package:flutter/material.dart';

class MatcheScreen extends StatelessWidget {
  MatcheScreen({super.key});

  bool isLoading = true;

  final ValueNotifier<ProfilesLikedMe> _profilesLikedMeNotifier =
      ValueNotifier(ProfilesLikedMe());
  final ValueNotifier<List<String>> likedProfilesIdNotifier = ValueNotifier([]);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      likedProfilesIdNotifier.value =
          await ProfileDB().getListFromSharedPreferences('LIKEDPROFILES');
      await _fetchProfiles();
    });
    return RefreshIndicator(
      onRefresh: () async {
        await _fetchProfiles();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'This is a list of people who have liked you.',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _profilesLikedMeNotifier,
              builder: (context, likedProfile, child) {
                if (!isLoading && likedProfile.profilesLikedMe != null) {
                  return ListView.builder(
                    itemCount: likedProfile.profilesLikedMe!.length,
                    itemBuilder: (context, index) {
                      final datedProfile = likedProfile.profilesLikedMe![index];
                      return ValueListenableBuilder(
                        valueListenable: likedProfilesIdNotifier,
                        builder: (context, userLikedId, child) {
                          return datedProfiles(
                            date: datedProfile.date,
                            profiles: datedProfile.profiles,
                            itemCount: datedProfile.profiles != null
                                ? datedProfile.profiles!.length
                                : 0,
                          );
                        },
                      );
                    },
                  );
                } else if (isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.red,
                    ),
                  );
                } else {
                  return const Center(
                    child: Text(
                      'No Profiles found',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xffE94057),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget datedProfiles(
      {String? date, List<Profile>? profiles, int? itemCount}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDateSection(date ?? 'date'),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.6,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemCount: profiles!.length,
          itemBuilder: (context, index) {
            final profile = profiles[index];
            final age = calculateAge(profile.dateOfBirth!);
            final isLiked =
                likedProfilesIdNotifier.value.contains(profile.userId);
            return MatchCard(
              profile.username ?? '',
              age.toString(),
              profile.profilePic ?? '',
              isLiked,
              profile.userId ?? '',
              () async {
                bool status;
                final likedIds =
                    List<String>.from(likedProfilesIdNotifier.value);
                if (isLiked) {
                  likedIds.remove(profile.userId);
                  likedProfilesIdNotifier.value = likedIds;
                  status =
                      await ProfileDB().unlikeProfile(profile.userId ?? '');
                  if (!status) {
                    likedIds.add(profile.userId!);
                    likedProfilesIdNotifier.value = likedIds;
                  }
                } else {
                  likedIds.add(profile.userId!);
                  likedProfilesIdNotifier.value = likedIds;
                  status = await ProfileDB().likeProfile(profile.userId ?? '');
                  if (!status) {
                    likedIds.remove(profile.userId!);
                    likedProfilesIdNotifier.value = likedIds;
                  }
                }
                if (status) {
                  await ProfileDB()
                      .updateLikedProfiles(profile.userId ?? '', !isLiked);
                }
              },
            );
          },
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Future<void> _fetchProfiles() async {
    try {
      isLoading = true;
      const maxRetries = 3;
      int retryCount = 0;
      bool retry = true;
      while (retry && retryCount < maxRetries) {
        retry = false;
        try {
          final result = await ProfileDB().profilesLikedMe();
          _profilesLikedMeNotifier.value = result;
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

  Widget _buildDateSection(String date) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              height: 1,
              color: Colors.grey,
            ),
          ),
          Text(
            date,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              height: 1,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class MatchCard extends StatelessWidget {
  final String id;
  final String name;
  final String age;
  final String imagePath;
  final bool isLiked;
  final VoidCallback onLikeChange;

  MatchCard(
    this.name,
    this.age,
    this.imagePath,
    this.isLiked,
    this.id,
    this.onLikeChange,
  );

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            '${Url().baseUrl}${imagePath}',
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 50,
              child: Stack(
                children: [
                  ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          '$name',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () => onLikeChange(),
                          icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                          ),
                          color: isLiked ? kColor : Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
