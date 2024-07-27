// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:diversid/gen/assets.gen.dart';
import 'package:diversid/src/constants/constants.dart';
import 'package:diversid/src/core/presentation/ktp/models/face_recognition.dart';
import 'package:diversid/src/core/presentation/ktp/views/camera_view_with_liveness.dart';
import 'package:diversid/src/core/presentation/ktp/views/capture_view.dart';
import 'package:diversid/src/core/presentation/ktp/views/computior_vision_view.dart';
import 'package:diversid/src/shared/extensions/extensions.dart';
import 'package:diversid/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CameraPage extends StatefulWidget {
  final KTPVerificationType ktpVerificationType;

  const CameraPage({
    super.key,
    required this.ktpVerificationType,
  });

  @override
  CameraPageState createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> {
  FaceRecognition detections = FaceRecognition();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final GlobalKey<CameraView2State> _cameraViewKey =
      GlobalKey<CameraView2State>();

  final GlobalKey<ComputerVisionViewState> _cvViewKey =
      GlobalKey<ComputerVisionViewState>();

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
                      resultsCallback: resultsCallback,
                    ),
                  )
                : ComputerVisionView(
                    key: _cvViewKey,
                    ktpVerificationType: widget.ktpVerificationType,
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

  void resultsCallback(FaceRecognition detections) {
    if (!mounted) return;

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
                        'KTP Kurang Jelas, Harap Posisikan KTP di tengah Kamera',
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
