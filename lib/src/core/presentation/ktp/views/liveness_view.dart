import 'package:diversid/src/core/presentation/ktp/models/face_recognition.dart';
import 'package:diversid/src/core/presentation/ktp/views/camera_view_with_liveness.dart';
import 'package:flutter/material.dart';

class LivenessView extends StatefulWidget {
  @override
  LivenessViewState createState() => LivenessViewState();
}

class LivenessViewState extends State<LivenessView> {
  FaceRecognition detections = FaceRecognition();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  GlobalKey<CameraView2State> _cameraViewKey = GlobalKey<CameraView2State>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          // Camera View
          CameraView2(
            key: _cameraViewKey,
            resultsCallback: resultsCallback,
          ),

          // Heading
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: const EdgeInsets.only(top: 20, left: 10),
              child: Text(
                'Face Liveness',
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

  void resultsCallback(FaceRecognition detections) {
    if (!mounted) return;

    setState(() {
      this.detections = detections;
    });
  }
}
