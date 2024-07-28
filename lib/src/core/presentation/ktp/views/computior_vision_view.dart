// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:diversid/src/core/presentation/ktp/models/detection.dart';
import 'package:diversid/src/core/presentation/ktp/models/enum_type.dart';
import 'package:diversid/src/core/presentation/ktp/views/bounding_box_widget.dart';
import 'package:diversid/src/core/presentation/ktp/views/capture_view.dart';
import 'package:flutter/material.dart';

import 'camera_view_with_yolo.dart';

class ComputerVisionView extends StatefulWidget {
  final KTPVerificationType ktpVerificationType;
  final Function(List<Detection> detections) resultsCallback;
  final Function(FaceAngle? angle) onFaceAngleDetected;

  const ComputerVisionView({
    super.key,
    required this.resultsCallback,
    required this.ktpVerificationType,
    required this.onFaceAngleDetected,
  });

  @override
  ComputerVisionViewState createState() => ComputerVisionViewState();
}

class ComputerVisionViewState extends State<ComputerVisionView> {
  List<Detection> detections = [];
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final GlobalKey<CameraViewState> _cameraViewKey =
      GlobalKey<CameraViewState>();

  void captureImage() {
    _cameraViewKey.currentState?.captureImage();
  }

  //Get Camera Type
  CameraType get cameraType {
    switch (widget.ktpVerificationType) {
      case KTPVerificationType.ktp:
        return CameraType.rear;
      case KTPVerificationType.selfie:
        return CameraType.front;
      case KTPVerificationType.liveness:
        return CameraType.front;
    }
  }

  // Get class detect
  ClassDetect get classDetect {
    switch (widget.ktpVerificationType) {
      case KTPVerificationType.ktp:
        return ClassDetect.ktp;
      case KTPVerificationType.selfie:
        return ClassDetect.all;
      case KTPVerificationType.liveness:
        return ClassDetect.all;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          // Camera View
          CameraView(
            key: _cameraViewKey,
            cameraType: cameraType,
            classDetect: classDetect,
            ktpVerificationType: widget.ktpVerificationType,
            resultsCallback: resultsCallback,
            captureCallback: captureCallback,
            onFaceAngleDetected: widget.onFaceAngleDetected,
          ),

          // Bounding boxes
          boundingBoxes(detections),
        ],
      ),
    );
  }

  Widget boundingBoxes(List<Detection> detections) {
    return Stack(
      children: detections
          .map((e) => BoundingBoxWidget(
                result: e,
              ))
          .toList(),
    );
  }

  void resultsCallback(List<Detection> detections) {
    if (!mounted) return;

    widget.resultsCallback(detections);

    setState(() {
      this.detections = detections;
    });
  }

  void captureCallback(String imagePath) {
    if (imagePath != "") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CaptureView(
            ktpVerificationType: widget.ktpVerificationType,
            imagePath: imagePath,
          ),
        ),
      );
    }
  }
}
