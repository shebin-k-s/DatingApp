import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:datingapp/widgets/TopSnackBarMessage.dart';

// ignore: non_constant_identifier_names
void ApiResponseUtil({
  required BuildContext context,
  required int response,
  required String constantErrorMessage,
  required VoidCallback onSuccess,
}) async {
  final _sharedPref = await SharedPreferences.getInstance();
  final message = _sharedPref.getString('MESSAGE');
  if (response == 200 || response == 201) {
    TopSnackBarMessage(
      context: context,
      message: message ?? 'Success',
      type: ContentType.success,
    );
    _sharedPref.remove('MESSAGE');

    onSuccess();
  } else {
    TopSnackBarMessage(
      context: context,
      message: message ?? constantErrorMessage,
      type: ContentType.error,
    );
    _sharedPref.remove('MESSAGE');
  }
}
