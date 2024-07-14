import 'package:diversid/src/constants/constants.dart';
import 'package:diversid/src/shared/extensions/extensions.dart';
import 'package:flutter/material.dart';

class DropdownWidget extends StatelessWidget {
  final String? title;
  final String hintText;
  final List<String> optionList;
  const DropdownWidget({
    super.key,
    this.title,
    required this.hintText,
    required this.optionList,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: TypographyApp.text1.black,
          ),
          Gap.h8,
        ],
        DropdownButtonFormField<String>(
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: ColorApp.divider,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: ColorApp.grey,
              ),
            ),
            filled: true,
            fillColor: ColorApp.white,
          ),
          hint: Text(
            hintText,
            style: TypographyApp.text1.black,
          ),
          onChanged: (String? newValue) {},
          items: optionList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
