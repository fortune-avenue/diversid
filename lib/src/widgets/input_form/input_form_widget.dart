import 'package:diversid/gen/assets.gen.dart';
import 'package:diversid/src/constants/constants.dart';
import 'package:diversid/src/shared/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum InputFormType {
  normal,
  password,
  button,
  phoneNumber,
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
  final FocusNode? focusNode;

  const InputFormWidget({
    super.key,
    required this.controller,
    this.hintText,
    this.onChanged,
    this.errorText,
    this.validator,
    this.prefix,
    this.suffix,
    this.maxLines = 1,
    this.title,
    this.focusNode,
  })  : inputFormType = InputFormType.normal,
        isObscure = false,
        readOnly = false,
        onTap = null,
        onObscureTap = null;

  InputFormWidget.phoneNumber({
    super.key,
    required this.controller,
    this.hintText,
    this.onChanged,
    this.errorText,
    this.validator,
    this.suffix,
    this.title,
    this.focusNode,
  })  : inputFormType = InputFormType.phoneNumber,
        isObscure = false,
        readOnly = false,
        maxLines = 1,
        prefix = Padding(
          padding: EdgeInsets.only(top: 2.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Gap.w8,
              Assets.icons.indonesia.svg(),
              Gap.w8,
              Text(
                '+62',
                style: TypographyApp.text1.primary.bold,
              ),
            ],
          ),
        ),
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
    this.maxLines = 1,
    this.title,
    this.focusNode,
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
    this.focusNode,
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
        Semantics(
          label: 'Masukkan $hintText',
          textField: true,
          excludeSemantics: true,
          child: TextFormField(
            focusNode: focusNode,
            controller: controller,
            onChanged: onChanged,
            obscureText: isObscure,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: validator,
            maxLines: maxLines,
            cursorColor: ColorApp.primary,
            decoration: InputDecoration(
              filled: true,
              errorText: errorText,
              fillColor: ColorApp.white,
              hintText: hintText,
              hintStyle: TypographyApp.text1.grey,
              prefixIcon: prefix,
              suffixIcon: isPassword
                  ? GestureDetector(
                      onTap: onObscureTap,
                      child: isObscure
                          ? const Icon(
                              Icons.visibility_rounded,
                              semanticLabel: 'Tunjukan Kata Sandi',
                              color: ColorApp.secondary,
                            )
                          : const Icon(
                              Icons.visibility_off_rounded,
                              semanticLabel: 'Sembunyikan Kata Sandi',
                              color: ColorApp.secondary,
                            ),
                    )
                  : suffix,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(
                  color: ColorApp.primary,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(
                  color: ColorApp.primary,
                  width: 2,
                ),
              ),
            ),
            readOnly: readOnly,
            onTap: onTap,
            style: inputFormType == InputFormType.phoneNumber
                ? TypographyApp.text1.primary.bold
                : TypographyApp.text1.black.bold,
          ),
        ),
      ],
    );
  }
}
