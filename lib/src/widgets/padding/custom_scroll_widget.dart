// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:diversid/src/shared/extensions/extensions.dart';
import 'package:flutter/material.dart';

class CustomScrollWidget extends StatelessWidget {
  final Widget child;
  const CustomScrollWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: SizedBox(
        height: context.screenHeight,
        child: child,
      ),
    );
  }
}
