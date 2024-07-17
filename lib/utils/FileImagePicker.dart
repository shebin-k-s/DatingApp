import 'dart:io';

import 'package:datingapp/widgets/TopSnackBarMessage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<void> FileImagePicker(
  BuildContext context,
  Function(File) onImageUploaded,
) async {
  final ImagePicker picker = ImagePicker();
  try {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final image = File(pickedFile.path);

      onImageUploaded(image);
    }
  } catch (e) {
    TopSnackBarMessage(
      context: context,
      message: 'Failed to upload image',
      type: ContentType.error,
    );
  }
}
