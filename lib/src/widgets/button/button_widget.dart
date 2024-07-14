import 'package:auto_size_text/auto_size_text.dart';
import 'package:diversid/src/constants/constants.dart';
import 'package:diversid/src/shared/extensions/extensions.dart';
import 'package:diversid/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum ButtonType {
  primary,
  secondary,
  outlined,
}

class ButtonWidget extends StatelessWidget {
  final ButtonType buttonType;
  final double? width;
  final String text;
  final Function()? onTap;
  final bool isLoading;
  final Widget? prefix;
  final Widget? sufix;
  final Color color;
  final Color focusColor;
  final bool _isEnabled;

  const ButtonWidget({
    super.key,
    required this.buttonType,
    required this.text,
    required this.color,
    required this.focusColor,
    this.width,
    this.onTap,
    this.isLoading = false,
    this.prefix,
    this.sufix,
    bool? isEnabled,
  }) : _isEnabled = isEnabled ?? onTap != null;

  const ButtonWidget.primary({
    this.width,
    super.key,
    this.onTap,
    this.isLoading = false,
    required this.text,
    this.prefix,
    this.sufix,
    bool? isEnabled,
  })  : buttonType = ButtonType.primary,
        color = ColorApp.red,
        focusColor = ColorApp.darkRed,
        _isEnabled = isEnabled ?? onTap != null;

  ButtonWidget.outlined({
    this.width,
    super.key,
    this.onTap,
    this.isLoading = false,
    required this.text,
    this.prefix,
    this.sufix,
    bool? isEnabled,
  })  : buttonType = ButtonType.outlined,
        color = ColorApp.white,
        focusColor = ColorApp.red.withOpacity(0.2),
        _isEnabled = isEnabled ?? onTap != null;

  ButtonWidget.secondary({
    this.width,
    super.key,
    this.onTap,
    this.isLoading = false,
    required this.text,
    this.prefix,
    this.sufix,
    bool? isEnabled,
  })  : buttonType = ButtonType.secondary,
        color = ColorApp.lightGrey,
        focusColor = ColorApp.grey.withOpacity(0.2),
        _isEnabled = isEnabled ?? onTap != null;

  bool get isPrimary => buttonType == ButtonType.primary;
  bool get isSecondary => buttonType == ButtonType.secondary;
  bool get isOutlined => buttonType == ButtonType.outlined;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Material(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
          side: isOutlined
              ? const BorderSide(color: ColorApp.red, width: 1)
              : BorderSide.none,
        ),
        child: InkWell(
          onTap: _isEnabled && !isLoading ? onTap : null,
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
            side: isOutlined
                ? const BorderSide(color: ColorApp.red, width: 1)
                : BorderSide.none,
          ),
          overlayColor: WidgetStateProperty.all(focusColor),
          focusColor: focusColor,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: SizeApp.w28,
              vertical: SizeApp.h8,
            ),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      height: SizeApp.customHeight(22),
                      width: SizeApp.customHeight(22),
                      child: const LoadingWidget(),
                    )
                  : prefix != null
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            prefix!,
                            Gap.w8,
                            AutoSizeText(
                              text,
                              style: getTextStyle(),
                              maxLines: 1,
                              minFontSize: 8,
                            )
                          ],
                        )
                      : sufix != null
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AutoSizeText(
                                  text,
                                  style: getTextStyle(),
                                  maxLines: 1,
                                  minFontSize: 8,
                                ),
                                Gap.w8,
                                sufix!,
                              ],
                            )
                          : AutoSizeText(
                              text,
                              style: getTextStyle(),
                              maxLines: 1,
                              minFontSize: 8,
                            ),
            ),
          ),
        ),
      ),
    );
  }

  TextStyle getTextStyle() {
    return _isEnabled
        ? isPrimary
            ? TypographyApp.text1.bold.white
            : isOutlined
                ? TypographyApp.text1.bold.red
                : TypographyApp.text1.bold.grey
        : TypographyApp.text1.bold.black;
  }
}
