import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

void TopSnackBarMessage({
  required BuildContext context,
  required String message,
  required ContentType type,
}) {
  final overlay = Overlay.of(context);
  switch (type) {
    case ContentType.success:
      showTopSnackBar(
        overlay,
        animationDuration: Duration(milliseconds: 300),
        reverseAnimationDuration: Duration(milliseconds: 300),
        CustomSnackBar.success(
          message: message,
          backgroundColor: Colors.green,
          icon: const Icon(
            Icons.check_circle,
            size: 26,
            color: Colors.white,
          ),
          iconPositionLeft: 20,
          iconRotationAngle: 0,
          textStyle: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          messagePadding: EdgeInsets.symmetric(horizontal: 56),
        ),
      );
      break;
    case ContentType.error:
      showTopSnackBar(
        overlay,
        animationDuration: Duration(milliseconds: 300),
        reverseAnimationDuration: Duration(milliseconds: 300),
        CustomSnackBar.error(
          message: message,
          backgroundColor: Color(0xffE94057),
          icon: const Icon(
            Icons.close_rounded,
            size: 26,
            color: Colors.white,
          ),
          iconPositionLeft: 20,
          iconRotationAngle: 0,
          textStyle: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          messagePadding: EdgeInsets.symmetric(horizontal: 56),
        ),
      );
      break;
    case ContentType.info:
      showTopSnackBar(
        overlay,
        animationDuration: Duration(milliseconds: 300),
        reverseAnimationDuration: Duration(milliseconds: 300),
        CustomSnackBar.info(
          message: message,
          backgroundColor: Colors.orange,
          icon: const Icon(
            Icons.info,
            size: 26,
            color: Colors.white,
          ),
          iconPositionLeft: 20,
          iconRotationAngle: 0,
          textStyle: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          messagePadding: EdgeInsets.symmetric(horizontal: 56),
        ),
      );
      break;
  }
}

enum ContentType { success, error, info }
