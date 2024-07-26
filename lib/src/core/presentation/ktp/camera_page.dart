import 'package:diversid/src/core/presentation/ktp/models/enum_type.dart';
import 'package:diversid/src/core/presentation/ktp/views/computior_vision_view.dart';
import 'package:flutter/material.dart';

class CameraPage extends StatefulWidget {
  final CameraType cameraType;
  final ClassDetect classDetect;
  final String pageTitle;

  CameraPage({
    required this.cameraType,
    required this.classDetect,
    required this.pageTitle,
  });

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  GlobalKey<ComputerVisionViewState> _cvViewKey =
      GlobalKey<ComputerVisionViewState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Header View
          headerView(),

          // Computer Vision View
          Expanded(
            child: ComputerVisionView(
              key: _cvViewKey,
              cameraType: widget.cameraType,
              classDetect: widget.classDetect,
            ),
          ),

          // Button View
          buttonView(),
        ],
      ),
    );
  }

  Widget headerView() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      color: Colors.grey[900],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context); // Go back to the previous screen
            },
          ),
          Expanded(
            child: Center(
              child: Text(
                widget.pageTitle,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buttonView() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      color: Colors.grey[900],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              _cvViewKey.currentState?.captureImage();
            },
            child: Text('Capture'),
          ),
        ],
      ),
    );
  }
}
