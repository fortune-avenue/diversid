import 'dart:math';
import 'package:diversid/src/core/presentation/ktp/views/camera_view_singleton.dart';
import 'package:flutter/cupertino.dart';
class Detection {
  Rect location;
  final String label;
  final double score;

  Detection(this.location, this.label, this.score);

  Rect get renderLocation {
    // adding some constants to prevent offset
    double ratioX = CameraViewSingleton.ratio;
    double ratioY = ratioX;

    double transLeft = max(0.1, location.left * ratioX);
    double transTop = max(0.1, location.top * ratioY);
    double transWidth = min(
        location.width * ratioX, CameraViewSingleton.actualPreviewSize.width);
    double transHeight = min(
        location.height * ratioY, CameraViewSingleton.actualPreviewSize.height);

    Rect transformedRect =
        Rect.fromLTWH(transLeft, transTop, transWidth, transHeight);

    return transformedRect;
  }

  @override
  String toString() {
    return 'Detection(label: $label, score: $score, location: $location)';
  }
}
