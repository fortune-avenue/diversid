// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:diversid/src/constants/constants.dart';
import 'package:flutter/material.dart';

class ChipWidget extends StatelessWidget {
  final String title;
  final EdgeInsets? padding;
  final Color color;
  final TextStyle? style;
  final Widget? prefix;
  final Widget? sufix;
  const ChipWidget({
    super.key,
    required this.title,
    this.padding,
    required this.color,
    this.style,
    this.prefix,
    this.sufix,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: color.withOpacity(0.1),
      ),
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          prefix ?? const SizedBox.shrink(),
          if (prefix != null) Gap.w4,
          Text(
            title,
            style: style?.copyWith(color: color) ??
                TypographyApp.text1.copyWith(color: color),
          ),
          if (sufix != null) Gap.w4,
          sufix ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
