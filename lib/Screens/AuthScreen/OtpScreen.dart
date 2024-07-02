import 'package:datingapp/Screens/MainScreen/MainScreen.dart';
import 'package:datingapp/Screens/OnboardingScreen/OnboardingScreen.dart';
import 'package:datingapp/Screens/RegisterScreen/ProfileRegisterScreen.dart';
import 'package:datingapp/api/data/Auth.dart';
import 'package:datingapp/widgets/ApiResponseUtil.dart';
import 'package:datingapp/widgets/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:otp_timer_button/otp_timer_button.dart';

class Otpscreen extends StatelessWidget {
  Otpscreen({
    super.key,
    required this.phoneNumber,
    required this.email,
    required this.forLogin,
  });

  final String phoneNumber;
  final String email;
  final bool forLogin;

  final OtpTimerButtonController controller = OtpTimerButtonController();
  final ValueNotifier<String> codeNotifier = ValueNotifier('');
  final ValueNotifier<bool> isLoadingNotifier = ValueNotifier(false);
  final ValueNotifier<bool> _isInputValid = ValueNotifier(false);

  void _requestOtp() async {
    controller.loading();
    await AuthDB().sendOTP(email, phoneNumber, forLogin);
    controller.startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(
          bottom: 40,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            OtpTimerButton(
              controller: controller,
              height: 60,
              text: const Text(
                'Resend OTP',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              duration: 10,
              radius: 30,
              backgroundColor: const Color(0xffE94057),
              textColor: Colors.white,
              buttonType: ButtonType.text_button,
              loadingIndicator: const CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xffE94057),
              ),
              loadingIndicatorColor: const Color(0xffE94057),
              onPressed: () {
                _requestOtp();
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Type the verification code',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: email.isNotEmpty
                    ? "We've sent to your email "
                    : "We've sent to your phone ",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: email.isNotEmpty ? email : phoneNumber,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xffE94057),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => ValueListenableBuilder(
                    valueListenable: codeNotifier,
                    builder: (context, value, child) {
                      return Container(
                        width: 50,
                        height: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                            color: index < value.length
                                ? const Color(0xffE94057)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: index < value.length + 1
                                  ? const Color(0xffE94057)
                                  : const Color(0xffE8E6EA),
                              width: 2,
                            )),
                        child: Center(
                          child: Text(
                            index < value.length ? value[index] : '',
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
            const Spacer(),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              childAspectRatio: 1.5,
              children: List.generate(12, (index) {
                if (index == 9) return Container();
                if (index == 11) {
                  return IconButton(
                    icon: const Icon(Icons.backspace),
                    onPressed: () {
                      if (codeNotifier.value.isNotEmpty) {
                        codeNotifier.value = codeNotifier.value
                            .substring(0, codeNotifier.value.length - 1);
                        _isInputValid.value = codeNotifier.value.length == 5;
                      }
                    },
                  );
                }
                int number = (index + 1) % 10;
                if (index == 10) {
                  number = 0;
                }
                return TextButton(
                  child: Text(
                    '$number',
                    style: const TextStyle(fontSize: 24, color: Colors.black),
                  ),
                  onPressed: () {
                    if (codeNotifier.value.length < 5) {
                      codeNotifier.value = '${codeNotifier.value}${number}';
                      _isInputValid.value = codeNotifier.value.length == 5;
                    }
                  },
                );
              }),
            ),
            const Spacer(),
            ValueListenableBuilder(
              valueListenable: _isInputValid,
              builder: (context, value, child) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(
                      double.infinity,
                      50,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor:
                        value ? const Color(0xffE94057) : Colors.grey,
                  ),
                  onPressed: () async {
                    if (_isInputValid.value && !isLoadingNotifier.value) {
                      isLoadingNotifier.value = true;
                      final response =
                          await AuthDB().verifyOTP(codeNotifier.value);

                      ApiResponseUtil(
                        context: context,
                        response: response,
                        constantErrorMessage: 'Failed to verify the OTP',
                        onSuccess: () {
                          if (forLogin) {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (ctx) => MainScreen()),
                              (route) => false,
                            );
                          } else {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (ctx) => ProfileRegisterScreen(),
                              ),
                            );
                          }
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
                          'Send',
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
    );
  }
}
