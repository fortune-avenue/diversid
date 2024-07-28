// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:isolate';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:diversid/src/core/presentation/ktp/models/detection.dart';
import 'package:diversid/src/core/presentation/ktp/models/enum_type.dart';
import 'package:diversid/src/core/presentation/ktp/models/face_recognition.dart';
import 'package:diversid/src/core/presentation/ktp/models/yolo_detection.dart';
import 'package:diversid/src/core/presentation/ktp/utils/isolate_util.dart';
import 'package:diversid/src/core/presentation/ktp/views/camera_view_singleton.dart';
import 'package:diversid/src/core/presentation/ktp/views/capture_view.dart';
import 'package:flutter/material.dart';

/// [CameraView] sends each frame for inference
class CameraView extends StatefulWidget {
  final CameraType cameraType;
  final ClassDetect classDetect;
  final KTPVerificationType ktpVerificationType;
  final Function(FaceAngle? angle) onFaceAngleDetected;
  final Function(String) captureCallback;

  /// Callback to pass results after inference to [HomeView]
  final Function(List<Detection> detections) resultsCallback;

  /// Constructor
  const CameraView({
    super.key,
    required this.cameraType,
    required this.classDetect,
    required this.ktpVerificationType,
    required this.onFaceAngleDetected,
    required this.captureCallback,
    required this.resultsCallback,
  });

  @override
  CameraViewState createState() => CameraViewState();
}

class CameraViewState extends State<CameraView> with WidgetsBindingObserver {
  List<CameraDescription>? cameras;
  CameraController? cameraController;
  bool predicting = false;
  late YOLODetection detection;
  late IsolateUtils isolateUtils;
  FaceRecognition faceRecognition = FaceRecognition();

  @override
  void initState() {
    super.initState();
    initStateAsync();
  }

  void initStateAsync() async {
    WidgetsBinding.instance.addObserver(this);

    // Spawn a new isolate
    isolateUtils = IsolateUtils();
    await isolateUtils.start(isSelfie: widget.classDetect == ClassDetect.all);

    // Camera initialization
    initializeCamera();

    // Create an instance of YOLODetection to load model and labels
    detection = YOLODetection();

    // Initially predicting = false
    predicting = false;
  }

  /// Initializes the camera by setting [cameraController]
  void initializeCamera() async {
    cameras = await availableCameras();
    CameraDescription selectedCamera = cameras!.firstWhere(
      (camera) =>
          camera.lensDirection ==
          (widget.cameraType == CameraType.front
              ? CameraLensDirection.front
              : CameraLensDirection.back),
    );

    cameraController = CameraController(
      selectedCamera,
      ResolutionPreset.high, // Change to a higher resolution if needed
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
    // Return empty container while the camera is not initialized
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return Container();
    }

    return AspectRatio(
      aspectRatio: CameraViewSingleton.ratio,
      child: CameraPreview(cameraController!),
    );
  }

  /// Callback to receive each frame [CameraImage] perform inference on it
  void onLatestImageAvailable(CameraImage cameraImage) async {
    // if (widget.ktpVerificationType == KTPVerificationType.selfie) {
    //   if (!predicting) {
    //     predicting = true;
    //     await faceRecognition.performFaceAngle(
    //       cameraImage,
    //       widget.onFaceAngleDetected,
    //     );
    //     setState(() {
    //       predicting = false;
    //     });
    //   }
    //   return;
    // }
    if (detection.interpreter != null && detection.labels != null) {
      // If previous inference has not completed then return
      if (predicting) {
        return;
      }

      setState(() {
        predicting = true;
      });

      // Data to be passed to inference isolate
      var rootToken = RootIsolateToken.instance!;

      var isolateData = IsolateData(
        cameraImage,
        detection.interpreter!.address,
        detection.labels!,
        ReceivePort().sendPort, // Pass a new SendPort
        rootToken,
      );

      // Perform inference in a separate isolate
      Map<String, dynamic> inferenceResults = await inference(isolateData);

      // Pass results to HomeView
      if (mounted) {
        widget.resultsCallback(
            inferenceResults["detections"] as List<Detection>? ?? []);
        widget.onFaceAngleDetected(inferenceResults["faceAngle"] as FaceAngle?);

        setState(() {
          predicting = false;
        });
      }
    }
  }

  Future<void> captureImage() async {
    if (cameraController!.value.isTakingPicture) {
      widget.captureCallback("");
      return;
    }

    try {
      XFile picture = await cameraController!.takePicture();
      widget.captureCallback(picture.path);
    } catch (e) {
      widget.captureCallback("");
      print(e);
    }
  }

  /// Runs inference in another isolate
  Future<Map<String, dynamic>> inference(IsolateData isolateData) async {
    ReceivePort responsePort = ReceivePort();
    isolateUtils.sendPort
        ?.send(isolateData..responsePort = responsePort.sendPort);
    var results = await responsePort.first;
    return results;
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
