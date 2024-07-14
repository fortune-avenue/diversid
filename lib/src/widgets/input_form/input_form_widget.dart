import 'package:diversid/src/constants/constants.dart';
import 'package:diversid/src/shared/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum InputFormType {
  normal,
  password,
  button,
}

class InputFormWidget extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final Function(String value)? onChanged;
  final bool isObscure;
  final Function()? onObscureTap;
  final InputFormType inputFormType;
  final bool readOnly;
  final VoidCallback? onTap;
  final String? errorText;
  final String? Function(String?)? validator;
  final Widget? prefix;
  final Widget? suffix;
  final int? maxLines;
  final String? title;

  const InputFormWidget({
    super.key,
    required this.controller,
    this.hintText,
    this.onChanged,
    this.errorText,
    this.validator,
    this.prefix,
    this.suffix,
    this.maxLines,
    this.title,
  })  : inputFormType = InputFormType.normal,
        isObscure = false,
        readOnly = false,
        onTap = null,
        onObscureTap = null;

  const InputFormWidget.button({
    super.key,
    required this.controller,
    required this.hintText,
    this.onTap,
    this.errorText,
    this.validator,
    this.prefix,
    this.suffix,
    this.maxLines,
    this.title,
  })  : inputFormType = InputFormType.button,
        isObscure = false,
        readOnly = true,
        onChanged = null,
        onObscureTap = null;

  const InputFormWidget.password({
    super.key,
    required this.controller,
    required this.hintText,
    this.onChanged,
    this.isObscure = true,
    this.onObscureTap,
    this.errorText,
    this.validator,
    this.prefix,
    this.suffix,
    this.maxLines = 1,
    this.title,
  })  : inputFormType = InputFormType.password,
        readOnly = false,
        onTap = null;

  bool get isPassword => inputFormType == InputFormType.password;

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
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          obscureText: isObscure,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator,
          maxLines: maxLines,
          cursorColor: ColorApp.grey,
          decoration: InputDecoration(
            filled: true,
            errorText: errorText,
            fillColor: ColorApp.white,
            hintText: hintText,
            hintStyle: TypographyApp.text1.grey,
            prefixIcon: prefix,
            suffixIcon: suffix,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(
                color: ColorApp.divider,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(
                color: ColorApp.grey,
                width: 2,
              ),
            ),
            suffix: isPassword
                ? GestureDetector(
                    onTap: onObscureTap,
                    child: Text(
                      isObscure ? 'SHOW' : 'HIDE',
                      style: TypographyApp.text1.grey,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          readOnly: readOnly,
          onTap: onTap,
          style: TypographyApp.text1.black.bold,
        ),
      ],
    );
  }
}
