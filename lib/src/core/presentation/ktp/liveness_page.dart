import 'package:diversid/src/core/presentation/ktp/camera_page.dart';
import 'package:diversid/src/core/presentation/ktp/views/capture_view.dart';
import 'package:flutter/material.dart';

class LivenessPage extends StatelessWidget {
  const LivenessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CameraPage(
      ktpVerificationType: KTPVerificationType.liveness,
    );
  }
}
