import 'dart:async';

import 'package:collection/collection.dart';
import 'package:diversid/gen/assets.gen.dart';
import 'package:diversid/src/constants/constants.dart';
import 'package:diversid/src/core/presentation/ktp/models/detection.dart';
import 'package:diversid/src/core/presentation/ktp/models/enum_type.dart';
import 'package:diversid/src/core/presentation/ktp/models/face_recognition.dart';
import 'package:diversid/src/core/presentation/ktp/views/camera_view_with_liveness.dart';
import 'package:diversid/src/core/presentation/ktp/views/capture_view.dart';
import 'package:diversid/src/core/presentation/ktp/views/computior_vision_view.dart';
import 'package:diversid/src/routes/routes.dart';
import 'package:diversid/src/services/services.dart';
import 'package:diversid/src/shared/extensions/extensions.dart';
import 'package:diversid/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class Anchor {
  final double left;
  final double top;
  final double width;
  final double height;

  Anchor(this.left, this.top, this.width, this.height);

  double get right => left + width;
  double get bottom => top + height;
}

class CameraPage extends ConsumerStatefulWidget {
  final KTPVerificationType ktpVerificationType;

  const CameraPage({
    super.key,
    required this.ktpVerificationType,
  });

  @override
  CameraPageState createState() => CameraPageState();
}

class CameraPageState extends ConsumerState<CameraPage> {
  FaceRecognition detections = FaceRecognition();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final GlobalKey<CameraView2State> _cameraViewKey =
      GlobalKey<CameraView2State>();

  final GlobalKey<ComputerVisionViewState> _cvViewKey =
      GlobalKey<ComputerVisionViewState>();

  String helperText = '';

  LivenessCriteria? prevCriteria;
  //ttsService
  TTSService get ttsService => ref.read(ttsServiceProvider);

  // get title based on ktp verification type
  String get title {
    switch (widget.ktpVerificationType) {
      case KTPVerificationType.ktp:
        return 'Foto KTP';
      case KTPVerificationType.selfie:
        return 'Foto Selfie';
      case KTPVerificationType.liveness:
        return 'Liveness';
    }
  }

  // get title based on ktp verification type
  String get desc {
    switch (widget.ktpVerificationType) {
      case KTPVerificationType.ktp:
        return 'Harap Arahkan Kamera ke KTP';
      case KTPVerificationType.selfie:
        return 'Harap Arahkan Kamera ke Wajah & KTP';
      case KTPVerificationType.liveness:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      key: scaffoldKey,
      body: Stack(
        children: [
          Positioned.fill(
            child: widget.ktpVerificationType == KTPVerificationType.liveness
                ? Scaffold(
                    backgroundColor: Colors.black,
                    body: CameraView2(
                      key: _cameraViewKey,
                      resultsCallback: livenessCallback,
                    ),
                  )
                : ComputerVisionView(
                    key: _cvViewKey,
                    ktpVerificationType: widget.ktpVerificationType,
                    resultsCallback: ktpCallback,
                    onFaceAngleDetected: selfieCallback,
                  ),
          ),
          Positioned.fill(
            child: widget.ktpVerificationType == KTPVerificationType.ktp
                ? Assets.images.ktpOverlay.image(
                    fit: BoxFit.cover,
                  )
                : widget.ktpVerificationType == KTPVerificationType.selfie
                    ? Assets.images.selfieOverlay.image(
                        fit: BoxFit.cover,
                      )
                    : const SizedBox.shrink(),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: headerView(),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: buttonView(),
          ),
        ],
      ),
    );
  }

  ktpCallback(List<Detection> detections) {
    if (widget.ktpVerificationType != KTPVerificationType.ktp) return;
    if (detections.isNotEmpty) {
      final detection =
          detections.firstWhereOrNull((element) => element.label == 'ktp');
      if (detection == null) return;
      if (detection.label == 'ktp') {
        double area =
            detection.renderLocation.width * detection.renderLocation.height;

        // Define the center anchor
        double anchorWidth = 318;
        double anchorHeight = 200;
        double anchorLeft = (context.screenWidth - anchorWidth) / 2;
        double anchorTop = (context.screenHeight - anchorHeight) / 2;

        Anchor anchor =
            Anchor(anchorLeft, anchorTop, anchorWidth, anchorHeight);

        // Compare bounding box with anchor
        if (detection.renderLocation.left < anchor.left) {
          helperText = 'KTP Terlalu Kiri';
        } else if (detection.renderLocation.right > anchor.right) {
          helperText = 'KTP Terlalu Kanan';
        } else if (detection.renderLocation.top < anchor.top) {
          helperText = 'KTP Terlalu Atas';
        } else if (detection.renderLocation.bottom > anchor.bottom) {
          helperText = 'KTP Terlalu Bawah';
        } else if (area < 35000) {
          helperText = 'KTP Terlalu Jauh';
        } else if (area > 57000) {
          helperText = 'KTP Terlalu Dekat';
        } else {
          helperText = 'KTP Sudah Pas';
        }
      }
    } else {
      helperText = 'KTP Tidak ada';
    }
    setState(() {
      helperText = helperText;
    });
    // debounce time for tts
    if (ttsService.isPlaying) return;
    ttsService.speak(helperText);
  }

  selfieCallback(FaceAngle? angle) {
    if (widget.ktpVerificationType != KTPVerificationType.selfie) return;
    if (angle != null) {
      switch (angle) {
        case FaceAngle.right:
          helperText = 'Wajah Terlalu Kanan';
          break;
        case FaceAngle.left:
          helperText = 'Wajah Terlalu Kiri';
          break;
        case FaceAngle.center:
          helperText = 'Wajah Sudah Pas';
          break;
        case FaceAngle.lookUp:
          helperText = 'Wajah Terlalu Atas';
          break;
        case FaceAngle.lookDown:
          helperText = 'Wajah Terlalu Bawah';
          break;
      }
    } else {
      helperText = 'Wajah Tidak Ditemukan';
    }
    setState(() {
      helperText = helperText;
    });
    // debounce time for tts
    if (ttsService.isPlaying) return;
    ttsService.speak(helperText);
  }

  Future<void> livenessCallback(FaceRecognition detections) async {
    if (widget.ktpVerificationType != KTPVerificationType.liveness) return;
    if (!mounted) return;
    if (detections.isLive) {
      setState(() {
        helperText = 'Liveness Berhasil';
      });
      context.goNamed(Routes.ktp.name);
      return;
    }
    final criteria = detections.checkingSequence[detections.completedChecks];
    if (prevCriteria == criteria) {
      return;
    } else {
      ttsService.stop();
    }
    prevCriteria = criteria;
    switch (criteria) {
      case LivenessCriteria.right:
        helperText = 'Pindahkan Kepala ke Kanan';
        break;
      case LivenessCriteria.left:
        helperText = 'Pindahkan Kepala ke Kiri';
        break;
      case LivenessCriteria.bottom:
        helperText = 'Pindahkan Kepala ke Bawah';
        break;
      case LivenessCriteria.top:
        helperText = 'Pindahkan Kepala ke Atas';
        break;
      case LivenessCriteria.smile:
        helperText = 'Senyumkan Wajah';
        break;
      case LivenessCriteria.blink:
        helperText = 'Tutup Mata';
        break;
      default:
        helperText = '';
    }
    setState(() {
      helperText = helperText;
    });
    ttsService.speak(helperText);

    setState(() {
      this.detections = detections;
    });
  }

  Widget headerView() {
    return SafeArea(
      child: PaddingWidget(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Spacer(),
              ],
            ),
            Gap.h16,
            Text(
              title,
              style: TypographyApp.headline1.white,
            ),
            Text(
              desc,
              style: TypographyApp.text1.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget buttonView() {
    return SafeArea(
      child: PaddingWidget(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: ColorApp.shadow,
                color: ColorApp.white,
              ),
              padding: EdgeInsets.all(16.h),
              child: PaddingWidget(
                child: Row(
                  children: [
                    Assets.images.speaker.image(
                      width: SizeApp.h32,
                      height: SizeApp.h32,
                    ),
                    Gap.w16,
                    Expanded(
                      child: Text(
                        helperText,
                        style: TypographyApp.text1.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Gap.h32,
            if (widget.ktpVerificationType != KTPVerificationType.liveness) ...[
              GestureDetector(
                onTap: () {
                  _cvViewKey.currentState?.captureImage();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.r),
                    color: ColorApp.white.withOpacity(0.3),
                  ),
                  height: SizeApp.h72,
                  width: SizeApp.h72,
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.r),
                        color: ColorApp.primary,
                      ),
                      height: SizeApp.h56,
                      width: SizeApp.h56,
                    ),
                  ),
                ),
              ),
              Gap.h32,
            ]
          ],
        ),
      ),
    );
  }
}
