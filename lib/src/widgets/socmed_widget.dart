import 'package:diversid/src/constants/constants.dart';
import 'package:flutter/material.dart';

class SocialMediaWidget extends StatelessWidget {
  final Widget icon;

  const SocialMediaWidget({
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: SizeApp.h32,
        height: SizeApp.h32,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(56),
        ),
        padding: const EdgeInsets.all(12),
        child: icon,
      ),
    );
  }
}
