import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:diversid/src/core/presentation/ktp/models/enum_type.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceRecognition {
  Map<LivenessCriteria, bool> livenessCheckingState = {};
  bool isLive = false;
  late FaceDetector _faceDetector;
  late List<LivenessCriteria> checkingSequence;
  int completedChecks = 0;

  FaceRecognition() {
    for (var criteria in LivenessCriteria.values) {
      livenessCheckingState[criteria] = false;
    }
    _initializeFaceDetector();
    _generateRandomCheckingSequence();
  }

  void _initializeFaceDetector() {
    final options = FaceDetectorOptions(
      enableClassification: true,
      enableContours: true,
      enableLandmarks: true,
      enableTracking: true,
      performanceMode: FaceDetectorMode.accurate,
    );
    _faceDetector = FaceDetector(options: options);
  }

  void _generateRandomCheckingSequence() {
    checkingSequence = LivenessCriteria.values.toList()..shuffle();
  }

  Future<void> performFaceDetection(CameraImage cameraImage) async {
    final inputImage = _processImageToInputImage(cameraImage);
    final List<Face> faces = await _faceDetector.processImage(inputImage);
    if (faces.isNotEmpty) {
      if (isLive) return;
      final face = faces[0];
      updateLivenessState(face);
    }
  }

  Future<void> performFaceAngle(
    CameraImage cameraImage,
    Function(FaceAngle? face) onFaceAnglDetected,
  ) async {
    final inputImage = _processImageToInputImage(cameraImage);
    final List<Face> faces = await _faceDetector.processImage(inputImage);
    print(faces);
    if (faces.isNotEmpty) {
      final face = faces[0];
      FaceAngle angle = readAngle(face);
      print(angle);
      onFaceAnglDetected(angle);
    } else {
      onFaceAnglDetected(null);
    }
  }

  FaceAngle readAngle(Face face) {
    // Get the head rotation angles
    final double? headEulerAngleY =
        face.headEulerAngleY; // Rotation around Y-axis (left/right)
    final double? headEulerAngleX =
        face.headEulerAngleX; // Rotation around X-axis (up/down)

    // Define thresholds for angle detection
    const double horizontalThreshold = 20.0;
    const double verticalThreshold = 15.0;

    if (headEulerAngleY != null) {
      if (headEulerAngleY > horizontalThreshold) {
        return FaceAngle.right;
      } else if (headEulerAngleY < -horizontalThreshold) {
        return FaceAngle.left;
      }
    }

    if (headEulerAngleX != null) {
      if (headEulerAngleX > verticalThreshold) {
        return FaceAngle.lookUp;
      } else if (headEulerAngleX < -verticalThreshold) {
        return FaceAngle.lookDown;
      }
    }

    return FaceAngle.center;
  }

  InputImage _processImageToInputImage(CameraImage cameraImage) {
    final WriteBuffer allBytes = WriteBuffer();
    for (Plane plane in cameraImage.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final imageSize =
        ui.Size(cameraImage.width.toDouble(), cameraImage.height.toDouble());

    const imageRotation = InputImageRotation.rotation0deg;

    final inputImageFormat =
        InputImageFormatValue.fromRawValue(cameraImage.format.raw) ??
            InputImageFormat.nv21;

    final bytesPerRow = cameraImage.planes[0].bytesPerRow;

    final inputImageData = InputImageMetadata(
      size: imageSize,
      rotation: imageRotation,
      format: inputImageFormat,
      bytesPerRow: bytesPerRow,
    );

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: inputImageData,
    );
  }

  void updateLivenessState(Face face) {
    // if (face.contours[FaceContourType.face] != null) {
    //   final faceContour = face.contours[FaceContourType.face]!;

    //   print(faceContour.type);
    // }

    final criteria = checkingSequence[completedChecks];

    if (!livenessCheckingState[criteria]!) {
      if (_checkCriteria(criteria, face)) {
        livenessCheckingState[criteria] = true;
        completedChecks += 1;
      }
    }
    checkLiveness();
  }

  bool _checkCriteria(LivenessCriteria criteria, Face face) {
    switch (criteria) {
      case LivenessCriteria.right:
        return face.headEulerAngleY != null && face.headEulerAngleY! > 30;
      case LivenessCriteria.left:
        return face.headEulerAngleY != null && face.headEulerAngleY! < -30;
      case LivenessCriteria.bottom:
        return face.headEulerAngleX != null && face.headEulerAngleX! < -10;
      case LivenessCriteria.top:
        return face.headEulerAngleX != null && face.headEulerAngleX! > 10;
      case LivenessCriteria.smile:
        return face.smilingProbability != null &&
            face.smilingProbability! > 0.8;
      case LivenessCriteria.blink:
        return (face.leftEyeOpenProbability != null &&
                face.leftEyeOpenProbability! < 0.1) ||
            (face.rightEyeOpenProbability != null &&
                face.rightEyeOpenProbability! < 0.1);
      default:
        return false;
    }
  }

  void checkLiveness() {
    isLive = livenessCheckingState.values.every((state) => state == true);
  }

  bool isLivenessCriteriaMet(LivenessCriteria criteria) {
    return livenessCheckingState[criteria] ?? false;
  }

  List<LivenessCriteria> getRemainingCriteria() {
    return livenessCheckingState.entries
        .where((entry) => !entry.value)
        .map((entry) => entry.key)
        .toList();
  }

  void resetLivenessState() {
    for (var criteria in LivenessCriteria.values) {
      livenessCheckingState[criteria] = false;
    }
    isLive = false;
    completedChecks = 0;
    _generateRandomCheckingSequence();
  }

  void dispose() {
    _faceDetector.close();
  }

  @override
  String toString() {
    String createSeparator(int length) => '-' * length;
    const lineWidth = 50;
    final separator = createSeparator(lineWidth);

    String checkingSequenceStatus =
        checkingSequence.asMap().entries.map((entry) {
      int index = entry.key;
      LivenessCriteria criteria = entry.value;
      String status = index < completedChecks
          ? '(Completed)'
          : index == completedChecks
              ? '(Current)'
              : '(Pending)';
      return '${index + 1}. $criteria $status';
    }).join('\n');

    String livenessTable = LivenessCriteria.values.map((criteria) {
      String status =
          livenessCheckingState[criteria] == true ? 'Completed' : 'Pending';
      return '${criteria.toString().padRight(20)} | $status';
    }).join('\n');

    return '''
$separator
Liveness Detection Status
$separator
Checking Sequence:
$checkingSequenceStatus
$separator
Liveness Checking State:
$livenessTable
$separator
Completed Checks: $completedChecks / ${LivenessCriteria.values.length}
Overall Liveness: ${isLive ? 'LIVE' : 'NOT LIVE'}
$separator
''';
  }
}
