import 'dart:io';

import 'package:datingapp/api/Url.dart';
import 'package:datingapp/api/data/Auth.dart';
import 'package:datingapp/api/data/profiles.dart';
import 'package:datingapp/api/models/user_model/user_model.dart';
import 'package:datingapp/main.dart';
import 'package:datingapp/utils/FileImagePicker.dart';
import 'package:datingapp/utils/GenderBottomSheet.dart';
import 'package:datingapp/widgets/CalenderBottomSheet.dart';
import 'package:datingapp/widgets/CustomAppBar.dart';
import 'package:datingapp/widgets/TopSnackBarMessage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class AccountSettingsScreen extends StatelessWidget {
  AccountSettingsScreen({super.key});

  final ValueNotifier<String> usernameNotifier = ValueNotifier('');
  final ValueNotifier<String> genderNotifier = ValueNotifier('');
  final ValueNotifier<DateTime?> dateOfBirthNotifier = ValueNotifier(null);
  final ValueNotifier<String> addressNotifier = ValueNotifier('');
  final ValueNotifier<String> profilePicNotifier = ValueNotifier('');
  final ValueNotifier<String> bioNotifier = ValueNotifier('');
  final ValueNotifier<String> emailNotifier = ValueNotifier('');
  final ValueNotifier<String> phoneNumberNotifier = ValueNotifier('');
  final ValueNotifier<List<String>?> photosNotifier = ValueNotifier([]);

  Future<UserModel> loadUserData() async {
    final sharedPref = await SharedPreferences.getInstance();
    final user = UserModel(
      username: sharedPref.getString('USERNAME'),
      email: sharedPref.getString('EMAIL'),
      gender: sharedPref.getString('GENDER'),
      dateOfBirth: DateTime.tryParse(sharedPref.getString('DATEOFBIRTH') ?? ''),
      interests: sharedPref.getStringList('INTERESTS'),
      photos: sharedPref.getStringList('PHOTOS'),
      matches: sharedPref.getStringList('MATCHES'),
      likedProfiles: sharedPref.getStringList('LIKEDPROFILES'),
      favouriteProfiles: sharedPref.getStringList('FAVOURITEPROFILES'),
      address: sharedPref.getString('ADDRESS'),
      createdAt: DateTime.tryParse(sharedPref.getString('CREATEDAT') ?? ''),
      profilePic: sharedPref.getString('PROFILEPIC'),
      bio: sharedPref.getString('BIO'),
      phoneNumber: sharedPref.getString('PHONENUMBER'),
    );

    usernameNotifier.value = user.username ?? '';
    genderNotifier.value = user.gender ?? '';
    dateOfBirthNotifier.value = user.dateOfBirth;
    addressNotifier.value = user.address ?? '';
    profilePicNotifier.value = user.profilePic ?? '';
    bioNotifier.value = user.bio ?? '';
    emailNotifier.value = user.email ?? '';
    phoneNumberNotifier.value = user.phoneNumber ?? '';
    photosNotifier.value = user.photos;

    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: Text(
          'Account Settings',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xffE94057),
          ),
        ),
      ),
      body: FutureBuilder<UserModel>(
        future: loadUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ValueListenableBuilder<String>(
                  valueListenable: profilePicNotifier,
                  builder: (context, value, child) =>
                      _buildProfilePicture(context, value),
                ),
                const SizedBox(height: 20),
                ValueListenableBuilder<String>(
                  valueListenable: usernameNotifier,
                  builder: (context, value, child) =>
                      _buildTextField('Username', Icons.person, value),
                ),
                const SizedBox(height: 10),
                ValueListenableBuilder<String>(
                  valueListenable: emailNotifier,
                  builder: (context, value, child) {
                    if (value.isNotEmpty) {
                      return _buildTextField(
                        'Email',
                        Icons.email,
                        value,
                        readOnly: true,
                      );
                    }
                    return Container();
                  },
                ),
                const SizedBox(height: 10),
                ValueListenableBuilder<String>(
                  valueListenable: phoneNumberNotifier,
                  builder: (context, value, child) {
                    if (value.isNotEmpty) {
                      return _buildTextField(
                        'Phone Number',
                        Icons.phone,
                        value,
                        readOnly: true,
                      );
                    }
                    return Container();
                  },
                ),
                const SizedBox(height: 10),
                ValueListenableBuilder<String>(
                  valueListenable: genderNotifier,
                  builder: (context, value, child) =>
                      _buildGenderDropdown(context, value),
                ),
                const SizedBox(height: 10),
                ValueListenableBuilder<DateTime?>(
                  valueListenable: dateOfBirthNotifier,
                  builder: (context, value, child) =>
                      _buildBirthDatePicker(context, value),
                ),
                const SizedBox(height: 10),
                ValueListenableBuilder<String>(
                  valueListenable: addressNotifier,
                  builder: (context, value, child) =>
                      _buildTextField('Address', Icons.home, value),
                ),
                const SizedBox(height: 10),
                ValueListenableBuilder<String>(
                  valueListenable: bioNotifier,
                  builder: (context, value, child) => _buildTextField(
                    'Bio',
                    Icons.description,
                    value,
                    maxLines: 3,
                  ),
                ),
                const SizedBox(height: 10),
                _buildInterestsList(snapshot.data!),
                const SizedBox(height: 10),
                _buildSaveButton(context),
                const SizedBox(height: 10),
                ValueListenableBuilder(
                  valueListenable: photosNotifier,
                  builder: (context, value, child) =>
                      _buildPhotosGrid(context, value),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfilePicture(BuildContext context, String profilePic) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage('${Url().baseUrl}$profilePic'),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 18,
              child: IconButton(
                icon: const Icon(
                  Icons.camera_alt,
                  size: 18,
                  color: Colors.black,
                ),
                onPressed: () {
                  FileImagePicker(
                    context,
                    (image) async {
                      final img = await AuthDB().uploadImage(image);
                      if (img != null) {
                        profilePicNotifier.value = img;
                      } else {
                        TopSnackBarMessage(
                          context: context,
                          message: 'Failed to upload image',
                          type: ContentType.error,
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, String initialValue,
      {int maxLines = 1, bool readOnly = false}) {
    return TextFormField(
      initialValue: initialValue,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
      minLines: 1,
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
      onChanged: (value) {
        if (label == 'Username') {
          usernameNotifier.value = value;
        } else if (label == 'Address') {
          addressNotifier.value = value;
        } else if (label == 'Bio') {
          bioNotifier.value = value;
        }
      },
    );
  }

  Widget _buildGenderDropdown(BuildContext context, String gender) {
    return ListTile(
      title: const Text('Gender'),
      subtitle: Text(gender),
      leading: const Icon(Icons.people),
      onTap: () async {
        GenderBottomSheet(
          context: context,
          onGenderSelect: (gender) {
            genderNotifier.value = gender;
          },
        );
      },
    );
  }

  Widget _buildBirthDatePicker(BuildContext context, DateTime? dateOfBirth) {
    return ListTile(
      title: const Text('Birth Date'),
      subtitle: Text(
        dateOfBirth != null
            ? DateFormat('yyyy-MM-dd').format(dateOfBirth)
            : 'Not set',
      ),
      leading: const Icon(Icons.calendar_today),
      onTap: () async {
        CalendarBottomSheet(
          context: context,
          initialDate: dateOfBirth ?? DateTime.now(),
          onDateSelected: (date) => dateOfBirthNotifier.value = date,
        );
      },
    );
  }

  Widget _buildInterestsList(UserModel user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Interests',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 8,
          children: (user.interests ?? [])
              .map((interest) => Chip(label: Text(interest)))
              .toList(),
        ),
        TextButton(
          onPressed: () {
            // Implement functionality to add/edit interests
          },
          child: const Text('Edit Interests'),
        ),
      ],
    );
  }

  Widget _buildPhotosGrid(BuildContext context, List<String>? photos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Photos',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.add_photo_alternate,
                size: 28,
              ),
              onPressed: () {
                FileImagePicker(
                  context,
                  (image) async {
                    final uploadedImg = await AuthDB().uploadImage(image);
                    if (uploadedImg != null) {
                      photosNotifier.value = [
                        ...?photosNotifier.value,
                        uploadedImg
                      ];
                    } else {
                      TopSnackBarMessage(
                        context: context,
                        message: 'Failed to upload image',
                        type: ContentType.error,
                      );
                    }
                  },
                );
              },
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: photos!.length,
          itemBuilder: (context, index) {
            return Image.network(
              '${Url().baseUrl}${photos[index]}',
            );
          },
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final updatedUser = UserModel(
            address: addressNotifier.value,
            bio: bioNotifier.value,
            profilePic: profilePicNotifier.value,
            username: usernameNotifier.value,
            gender: genderNotifier.value,
            dateOfBirth: dateOfBirthNotifier.value,
            photos: photosNotifier.value);
        int status = await ProfileDB().editProfile(updatedUser);
        final sharedPref = await SharedPreferences.getInstance();
        final message = sharedPref.getString('MESSAGE');
        if (message != null) {
          TopSnackBarMessage(
            context: context,
            message: message,
            type: status == 200 ? ContentType.success : ContentType.error,
          );
        }
      },
      child: const Text('Save Changes'),
    );
  }
}
