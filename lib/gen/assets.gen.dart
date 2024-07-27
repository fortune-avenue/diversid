/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vector_graphics/vector_graphics.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/additional_info.svg
  SvgGenImage get additionalInfo =>
      const SvgGenImage('assets/icons/additional_info.svg');

  /// File path: assets/icons/address.svg
  SvgGenImage get address => const SvgGenImage('assets/icons/address.svg');

  /// File path: assets/icons/indonesia.svg
  SvgGenImage get indonesia => const SvgGenImage('assets/icons/indonesia.svg');

  /// File path: assets/icons/ktp_verification.svg
  SvgGenImage get ktpVerification =>
      const SvgGenImage('assets/icons/ktp_verification.svg');

  /// File path: assets/icons/otp.svg
  SvgGenImage get otp => const SvgGenImage('assets/icons/otp.svg');

  /// File path: assets/icons/personal_information.svg
  SvgGenImage get personalInformation =>
      const SvgGenImage('assets/icons/personal_information.svg');

  /// File path: assets/icons/voice_biometric.svg
  SvgGenImage get voiceBiometric =>
      const SvgGenImage('assets/icons/voice_biometric.svg');

  /// List of all assets
  List<SvgGenImage> get values => [
        additionalInfo,
        address,
        indonesia,
        ktpVerification,
        otp,
        personalInformation,
        voiceBiometric
      ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/elipse.png
  AssetGenImage get elipse => const AssetGenImage('assets/images/elipse.png');

  /// File path: assets/images/ktp_overlay.png
  AssetGenImage get ktpOverlay =>
      const AssetGenImage('assets/images/ktp_overlay.png');

  /// File path: assets/images/line_pattern.png
  AssetGenImage get linePattern =>
      const AssetGenImage('assets/images/line_pattern.png');

  /// File path: assets/images/selfie_overlay.png
  AssetGenImage get selfieOverlay =>
      const AssetGenImage('assets/images/selfie_overlay.png');

  /// File path: assets/images/speaker.png
  AssetGenImage get speaker => const AssetGenImage('assets/images/speaker.png');

  /// List of all assets
  List<AssetGenImage> get values =>
      [elipse, ktpOverlay, linePattern, selfieOverlay, speaker];
}

class $AssetsSvgsGen {
  const $AssetsSvgsGen();

  /// File path: assets/svgs/eye.svg
  SvgGenImage get eye => const SvgGenImage('assets/svgs/eye.svg');

  /// File path: assets/svgs/line.svg
  SvgGenImage get line => const SvgGenImage('assets/svgs/line.svg');

  /// File path: assets/svgs/logo_primary.svg
  SvgGenImage get logoPrimary =>
      const SvgGenImage('assets/svgs/logo_primary.svg');

  /// File path: assets/svgs/logo_white.svg
  SvgGenImage get logoWhite => const SvgGenImage('assets/svgs/logo_white.svg');

  /// File path: assets/svgs/onboarding1.svg
  SvgGenImage get onboarding1 =>
      const SvgGenImage('assets/svgs/onboarding1.svg');

  /// File path: assets/svgs/onboarding2.svg
  SvgGenImage get onboarding2 =>
      const SvgGenImage('assets/svgs/onboarding2.svg');

  /// File path: assets/svgs/onboarding3.svg
  SvgGenImage get onboarding3 =>
      const SvgGenImage('assets/svgs/onboarding3.svg');

  /// File path: assets/svgs/onboarding4.svg
  SvgGenImage get onboarding4 =>
      const SvgGenImage('assets/svgs/onboarding4.svg');

  /// File path: assets/svgs/upload.svg
  SvgGenImage get upload => const SvgGenImage('assets/svgs/upload.svg');

  /// List of all assets
  List<SvgGenImage> get values => [
        eye,
        line,
        logoPrimary,
        logoWhite,
        onboarding1,
        onboarding2,
        onboarding3,
        onboarding4,
        upload
      ];
}

class Assets {
  Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsSvgsGen svgs = $AssetsSvgsGen();
  static const String yoloTflite = 'assets/yolo.tflite';
  static const String yoloTxt = 'assets/yolo.txt';
  static const String yolo2Tflite = 'assets/yolo2.tflite';
  static const String yolo2Txt = 'assets/yolo2.txt';

  /// List of all assets
  static List<String> get values =>
      [yoloTflite, yoloTxt, yolo2Tflite, yolo2Txt];
}

class AssetGenImage {
  const AssetGenImage(this._assetName, {this.size = null});

  final String _assetName;

  final Size? size;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class SvgGenImage {
  const SvgGenImage(
    this._assetName, {
    this.size = null,
  }) : _isVecFormat = false;

  const SvgGenImage.vec(
    this._assetName, {
    this.size = null,
  }) : _isVecFormat = true;

  final String _assetName;

  final Size? size;
  final bool _isVecFormat;

  SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    SvgTheme? theme,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    return SvgPicture(
      _isVecFormat
          ? AssetBytesLoader(_assetName,
              assetBundle: bundle, packageName: package)
          : SvgAssetLoader(_assetName,
              assetBundle: bundle, packageName: package),
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      theme: theme,
      colorFilter: colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
