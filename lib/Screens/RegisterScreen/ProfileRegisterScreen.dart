import 'dart:io';

import 'package:datingapp/Screens/RegisterScreen/InterestScreen.dart';
import 'package:datingapp/api/data/Auth.dart';
import 'package:datingapp/api/models/user_model/user_model.dart';
import 'package:datingapp/widgets/CalenderBottomSheet.dart';
import 'package:datingapp/widgets/CustomAppBar.dart';
import 'package:datingapp/widgets/GenderSelector.dart';
import 'package:datingapp/widgets/TopSnackBarMessage.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ProfileRegisterScreen extends StatelessWidget {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final DateTime _focusedDate = DateTime(2000, 7, 11);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String gender = '';

  ProfileRegisterScreen({super.key});
  bool isFirstPress = true;
  final ValueNotifier<File?> _imageNotifier = ValueNotifier<File?>(null);
  final ImagePicker _picker = ImagePicker();
  String? imgUrl = '';

  Future<void> getImage(BuildContext context) async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _imageNotifier.value = File(pickedFile.path);

        imgUrl = await AuthDB().uploadImage(_imageNotifier.value!);
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
      TopSnackBarMessage(
        context: context,
        message: 'Failed to upload image',
        type: ContentType.error,
      );
    }
  }

  Future<bool> handleBackPress(BuildContext context) async {
    if (isFirstPress) {
      isFirstPress = false;
      TopSnackBarMessage(
        context: context,
        message: 'If you go back you need to verify again.',
        type: ContentType.info,
      );
      Future.delayed(const Duration(seconds: 10), () {
        isFirstPress = true;
      });
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DoubleBack(
      message: '',
      onFirstBackPress: handleBackPress,
      child: Scaffold(
        appBar: CustomAppBar(
          onBackPressed: () async {
            if (await handleBackPress(context)) {
              Navigator.of(context).pop();
            }
          },
        ),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 40,
              top: 20,
              left: 20,
              right: 20,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Profile details',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          child: GestureDetector(
                            onTap: () => getImage(context),
                            child: ClipOval(
                              child: ValueListenableBuilder<File?>(
                                valueListenable: _imageNotifier,
                                builder: (context, image, _) {
                                  return image != null
                                      ? Image.file(
                                          image,
                                          fit: BoxFit.cover,
                                          width: 100,
                                          height: 100,
                                        )
                                      : Image.asset(
                                          'assets/dummyprofile.png',
                                          fit: BoxFit.cover,
                                          width: 100,
                                          height: 100,
                                        );
                                },
                              ),
                            ),
                          ),
                        ),
                        const Positioned(
                          right: 0,
                          bottom: 0,
                          child: CircleAvatar(
                            backgroundColor: Color(0xffE94057),
                            radius: 15,
                            child: Icon(
                              Icons.camera_alt,
                              size: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildTextField(_firstNameController, 'First name'),
                  const SizedBox(height: 10),
                  _buildTextField(_lastNameController, 'Last name'),
                  const SizedBox(height: 10),
                  _buildTextField(_addressController, 'Address'),
                  const SizedBox(height: 10),
                  _buildBirthdayField(context),
                  const SizedBox(height: 10),
                  _buildGenderSelector(),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        DateFormat dateFormat = DateFormat('dd-MM-yyyy');
                        final dateOfBirth =
                            dateFormat.parseStrict(_birthdayController.text);
                        final user = UserModel(
                          username:
                              '${_firstNameController.text} ${_lastNameController.text}',
                          address: _addressController.text,
                          dateOfBirth: dateOfBirth,
                          gender: gender,
                          profilePic: imgUrl,
                        );
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => InterestScreen(
                              user: user,
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: const Color(0xffE94057),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return SizedBox(
      height: 80,
      child: TextFormField(
        controller: controller,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.grey[800],
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 18),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          errorStyle: const TextStyle(
            fontSize: 14,
          ),
          errorMaxLines: 1,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildBirthdayField(BuildContext context) {
    return SizedBox(
      height: 80,
      child: TextFormField(
        controller: _birthdayController,
        readOnly: true,
        onTap: () {
          CalendarBottomSheet(
            context: context,
            initialDate: _focusedDate,
            onDateSelected: (date) {
              _birthdayController.text = DateFormat('dd-MM-yyyy').format(date);
            },
          );
        },
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.grey[800],
        ),
        decoration: const InputDecoration(
          suffixIcon: Icon(Icons.calendar_month),
          labelText: 'Birthday',
          labelStyle: TextStyle(fontSize: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          errorStyle: TextStyle(
            fontSize: 14,
          ),
          errorMaxLines: 1,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select your birthday';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildGenderSelector() {
    return SizedBox(
      height: 80,
      child: GenderSelector(
        onGenderSelect: (selectedGender) {
          gender = selectedGender;
          print('gender: $gender');
        },
      ),
    );
  }
}
