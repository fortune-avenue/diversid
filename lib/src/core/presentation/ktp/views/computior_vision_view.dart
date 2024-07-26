import 'package:diversid/src/core/presentation/ktp/models/detection.dart';
import 'package:diversid/src/core/presentation/ktp/models/enum_type.dart';
import 'package:diversid/src/core/presentation/ktp/views/bounding_box_widget.dart';
import 'package:diversid/src/core/presentation/ktp/views/capture_view.dart';
import 'package:flutter/material.dart';

import 'camera_view_with_yolo.dart';

class ComputerVisionView extends StatefulWidget {
  final CameraType cameraType;
  final ClassDetect classDetect;

  ComputerVisionView({
    required Key key,
    required this.cameraType,
    required this.classDetect,
  }) : super(key: key);

  @override
  ComputerVisionViewState createState() => ComputerVisionViewState();
}

class ComputerVisionViewState extends State<ComputerVisionView> {
  List<Detection> detections = [];
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  GlobalKey<CameraViewState> _cameraViewKey = GlobalKey<CameraViewState>();

  void captureImage() {
    _cameraViewKey.currentState?.captureImage();
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
            cameraType: widget.cameraType,
            classDetect: widget.classDetect,
            resultsCallback: resultsCallback,
            captureCallback: captureCallback,
          ),

          // Bounding boxes
          boundingBoxes(detections),

          // Heading
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: const EdgeInsets.only(top: 20, left: 10),
              child: Text(
                'Object Detection Flutter',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrangeAccent.withOpacity(0.6),
                ),
              ),
            ),
          ),
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

    setState(() {
      this.detections = detections;
    });
  }

  void captureCallback(String imagePath) {
    if (imagePath != "") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CaptureView(imagePath: imagePath),
        ),
      );
    }
  }
}
