import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final Widget? title;
  final bool showBackButton;
  final bool centerTitle;

  const CustomAppBar({
    super.key,
    this.onBackPressed,
    this.centerTitle = true,
    this.actions,
    this.title,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: AppBar(
          forceMaterialTransparency: true,
          leading: showBackButton
              ? GestureDetector(
                  onTap: onBackPressed ?? () => Navigator.of(context).pop(),
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.chevron_left,
                        color: Color(0xffE94057),
                        size: 30,
                      ),
                    ),
                  ),
                )
              : null,
          title: title,
          actions: actions,
          centerTitle: centerTitle,
          elevation: 0,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
