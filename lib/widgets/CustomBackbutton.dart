import 'package:flutter/material.dart';

AppBar CustomBackbutton(BuildContext context, {VoidCallback? onPressed}) {
  return AppBar(
    leadingWidth: 60,
    leading: Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 8.0, bottom: 8.0),
      child: GestureDetector(
        onTap: () {
          if (onPressed != null) {
            onPressed();
          } else {
            Navigator.of(context).pop();
          }
        },
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.chevron_left,
              color: Color(0xffE94057),
              size: 34,
            ),
          ),
        ),
      ),
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
  );
}
