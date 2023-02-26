import 'package:flutter/material.dart';

/// Custom app bar for the add field screen
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function() onPressed;
  const CustomAppBar({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.transparent,
        height: 100,
        padding: const EdgeInsets.all(
          16,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 30,
              ),
              onPressed: onPressed,
            ),
            const SizedBox(
              width: 15,
            ),
            const Text(
              'Add new field',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto',
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(75);
}
