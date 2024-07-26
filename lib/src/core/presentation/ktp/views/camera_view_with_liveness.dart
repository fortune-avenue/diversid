import 'package:camera/camera.dart';
import 'package:diversid/src/core/presentation/ktp/models/face_recognition.dart';
import 'package:diversid/src/core/presentation/ktp/views/camera_view_singleton.dart';
import 'package:flutter/material.dart';

class CameraView2 extends StatefulWidget {
  final Function(FaceRecognition) resultsCallback;

  CameraView2({
    required Key key,
    required this.resultsCallback,
  }) : super(key: key);

  @override
  CameraView2State createState() => CameraView2State();
}

class CameraView2State extends State<CameraView2> with WidgetsBindingObserver {
  List<CameraDescription>? cameras;
  CameraController? cameraController;
  bool predicting = false;
  FaceRecognition faceRecognition = FaceRecognition();

  @override
  void initState() {
    super.initState();
    initStateAsync();
  }

  void initStateAsync() async {
    WidgetsBinding.instance.addObserver(this);
    initializeCamera();
    predicting = false;
  }

  void initializeCamera() async {
    cameras = await availableCameras();
    CameraDescription selectedCamera = cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front);
    cameraController = CameraController(
      selectedCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    cameraController?.initialize().then((_) async {
      if (!mounted) {
        return;
      }
      await cameraController?.startImageStream(onLatestImageAvailable);
      Size previewSize = cameraController!.value.previewSize!;
      CameraViewSingleton.inputImageSize = previewSize;
      Size screenSize = MediaQuery.of(context).size;
      CameraViewSingleton.screenSize = screenSize;
      CameraViewSingleton.ratio = previewSize.height / previewSize.width;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return Container();
    }
    return AspectRatio(
        aspectRatio: CameraViewSingleton.ratio,
        child: CameraPreview(cameraController!));
  }

  void onLatestImageAvailable(CameraImage cameraImage) async {
    if (!predicting) {
      predicting = true;
      await faceRecognition.performFaceDetection(cameraImage);
      widget.resultsCallback(faceRecognition);
      setState(() {
        predicting = false;
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.paused:
        cameraController!.stopImageStream();
        break;
      case AppLifecycleState.resumed:
        if (!cameraController!.value.isStreamingImages) {
          await cameraController!.startImageStream(onLatestImageAvailable);
        }
        break;
      default:
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    cameraController?.dispose();
    super.dispose();
  }
}
