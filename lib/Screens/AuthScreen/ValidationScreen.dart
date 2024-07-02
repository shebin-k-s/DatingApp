import 'package:datingapp/Screens/AuthScreen/OtpScreen.dart';
import 'package:datingapp/api/data/Auth.dart';
import 'package:datingapp/widgets/ApiResponseUtil.dart';
import 'package:datingapp/widgets/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

// ignore: must_be_immutable
class Validationscreen extends StatelessWidget {
  Validationscreen({super.key, required this.isPhone, required this.forLogin});

  final bool isPhone;
  final bool forLogin;
  String _phoneNumber = '';
  String _phoneCode = '+91';

  final ValueNotifier<bool> isLoadingNotifier = ValueNotifier(false);

  final ValueNotifier<bool> _isInputValid = ValueNotifier(false);
  final TextEditingController _emailController = TextEditingController();
  PhoneNumber? _currentPhoneNumber;

  void _validatePhoneNumber() {
    if (_currentPhoneNumber != null) {
      try {
        _isInputValid.value = _currentPhoneNumber!.isValidNumber();
      } catch (e) {
        _isInputValid.value = false;
      }
    } else {
      _isInputValid.value = false;
    }
    print('Phone valid: ${_isInputValid.value}');
  }

  void _validateEmail() {
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    _isInputValid.value = emailRegExp.hasMatch(_emailController.text);
    print('Email valid: ${_isInputValid.value}');
  }

  @override
  Widget build(BuildContext context) {
    _validateEmail();
    return Scaffold(
      appBar: const CustomAppBar(),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text(
                isPhone ? 'My mobile' : 'My email',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Please enter your valid ${isPhone ? 'phone number' : 'email address'}. We will\nsend you a 5-digit code to verify your account.',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 30),
              if (isPhone)
                IntlPhoneField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                  initialCountryCode: 'IN',
                  onChanged: (phone) {
                    _phoneNumber = phone.number;
                    _currentPhoneNumber = phone;
                    _validatePhoneNumber();
                  },
                  onCountryChanged: (value) {
                    _phoneCode = '+${value.dialCode}';
                    if (_currentPhoneNumber != null) {
                      _currentPhoneNumber = PhoneNumber(
                        countryCode: value.code,
                        countryISOCode: value.code,
                        number: _phoneNumber,
                      );
                      _validatePhoneNumber();
                    }
                  },
                )
              else
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (_) => _validateEmail(),
                ),
              const SizedBox(height: 20),
              ValueListenableBuilder(
                valueListenable: _isInputValid,
                builder: (context, value, child) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: value ? const Color(0xffE94057) : Colors.grey,
                    ),
                    onPressed: () async {
                      if (_isInputValid.value && !isLoadingNotifier.value) {
                        FocusScope.of(context).unfocus();
                        isLoadingNotifier.value = true;
                        final response;
                        final String phoneNumber =
                            '${_phoneCode}${_phoneNumber}';
                        if (isPhone) {
                          response = await AuthDB()
                              .sendOTP('', phoneNumber, forLogin);
                        } else {
                          final String email = _emailController.text;
                          response =
                              await AuthDB().sendOTP(email, '', forLogin);
                        }
                        ApiResponseUtil(
                          context: context,
                          response: response,
                          constantErrorMessage:
                              'Failed to verify the ${isPhone ? 'phone number' : 'email address'}',
                          onSuccess: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => Otpscreen(
                                  email: _emailController.text,
                                  phoneNumber: phoneNumber,
                                  forLogin: forLogin,
                                ),
                              ),
                            );
                          },
                        );
                        isLoadingNotifier.value = false;
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
                          return const Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
