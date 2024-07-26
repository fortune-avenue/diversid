import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:image/image.dart' as imageLib;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

import 'detection.dart'; // Adjust import path as needed

class YOLODetection {
  Interpreter? _interpreter;
  List<String>? _labels;

  static const String MODEL_FILE_NAME = "yolo.tflite";
  static const String LABEL_FILE_NAME = "yolo.txt";

  static const int INPUT_SIZE = 640;

  static const double CONFIDENCE_THRESHOLD = 0.7;
  static const double IOU_THRESHOLD = 0.45;

  ImageProcessor? imageProcessor;

  late int padSize;

  List<List<int>>? _outputShapes;
  List<TfLiteType>? _outputTypes;

  /// Number of results to show
  static const int NUM_RESULTS = 10;

  YOLODetection({Interpreter? interpreter, List<String>? labels}) {
    loadModel(interpreter: interpreter);
    loadLabels(labels: labels);
  }

  /// Loads interpreter from asset
  Future<void> loadModel({Interpreter? interpreter}) async {
    try {
      _interpreter = interpreter ??
          await Interpreter.fromAsset(
            MODEL_FILE_NAME,
            options: InterpreterOptions()..threads = 4,
          );

      var outputTensors = _interpreter!.getOutputTensors();
      _outputShapes = [];
      _outputTypes = [];
      for (var tensor in outputTensors) {
        _outputShapes!.add(tensor.shape);
        _outputTypes!.add(tensor.type);
      }
    } catch (e) {
      print("Error while creating interpreter: $e");
    }
  }

  /// Loads labels from assets
  Future<void> loadLabels({List<String>? labels}) async {
    try {
      _labels =
          labels ?? await FileUtil.loadLabels("assets/$LABEL_FILE_NAME");
    } catch (e) {
      print("Error while loading labels: $e");
    }
  }

  /// Pre-process the image
  TensorBuffer getProcessedImage(imageLib.Image image) {
    // Resize image to 640x640
    final resizedImage =
        imageLib.copyResize(image, width: INPUT_SIZE, height: INPUT_SIZE);

    // Create a 4D tensor buffer for the input
    final inputBuffer = Int32List.fromList(
      List.generate(
        INPUT_SIZE * INPUT_SIZE * 3,
        (index) {
          final x = index % INPUT_SIZE;
          final y = (index ~/ INPUT_SIZE) % INPUT_SIZE;
          final pixel = resizedImage.getPixel(x, y);

          // Extract color channels
          final r = (pixel >> 16) & 0xFF;
          final g = (pixel >> 8) & 0xFF;
          final b = pixel & 0xFF;

          // Return pixel value in int32 format (flattened RGB channels)
          return index % 3 == 0
              ? r
              : index % 3 == 1
                  ? g
                  : b;
        },
      ),
    );

    // Create TensorBuffer with the shape [1, 640, 640, 3]
    final tensorBuffer = TensorBuffer.createFixedSize(
      [1, INPUT_SIZE, INPUT_SIZE, 3],
      TfLiteType.float32,
    );

    // Copy data to TensorBuffer
    tensorBuffer.loadBuffer(inputBuffer.buffer);

    return tensorBuffer;
  }

  /// Runs object detection on the input image
  Map<String, dynamic> predict(imageLib.Image image) {
    if (_interpreter == null) {
      print("Interpreter not initialized");
      return {};
    }

    // Create TensorImage from image
    TensorImage inputImage = TensorImage.fromImage(image);
    imageProcessor = ImageProcessorBuilder()
        .add(ResizeOp(640, 640, ResizeMethod.BILINEAR))
        .add(NormalizeOp(0, 255))
        .build();

    inputImage = imageProcessor!.process(inputImage);
    TensorBuffer inputBuffer = inputImage.getTensorBuffer();
    var reshapedInputBuffer =
        TensorBuffer.createFixedSize([1, 640, 640, 3], TfLiteType.float32);
    reshapedInputBuffer.loadBuffer(inputBuffer.getBuffer());

    // Define the output shape [1, 6, 8400]
    var output = TensorBuffer.createFixedSize([1, 6, 8400], TfLiteType.float32);

    // Run inference
    _interpreter!.run(reshapedInputBuffer.buffer, output.buffer);

    // Process the output (this will depend on your model's specific output format)
    // For example:
    List<dynamic> rawOutput = output.getDoubleList().reshape([1, 6, 8400]);
    List<List<List<double>>> outputArray = castOutput(rawOutput);

    // print(
    //     "Reshaped output array shape: ${outputArray.length}x${outputArray[0].length}x${outputArray[0][0].length}");

// Process the output
    List<Detection> detections =
        _processOutput(outputArray, image.width, image.height);

    return {
      "detections": detections,
    };
  }

  /// Process output tensors to extract detections
  // List<Detection> _processOutput(
  //     List<List<List<double>>> output, int width, int height) {
  //   // Transpose the output from [1, 6, 8400] to [1, 8400, 6]
  //   List<List<List<double>>> transposedOutput = _transposeOutput(output);

  //   final int numPredictions = transposedOutput[0].length;
  //   final int numClasses =
  //       transposedOutput[0][0].length - 4; // Subtract 4 for x, y, w, h

  //   List<Detection> detections = [];

  //   for (int i = 0; i < numPredictions; i++) {
  //     List<double> classScores = transposedOutput[0][i].sublist(4);

  //     double maxScore = classScores.reduce(max);
  //     if (maxScore >= CONFIDENCE_THRESHOLD) {
  //       int classIndex = classScores.indexOf(maxScore);

  //       // Calculate bounding box coordinates
  //       double x = transposedOutput[0][i][0];
  //       double y = transposedOutput[0][i][1];
  //       double w = transposedOutput[0][i][2];
  //       double h = transposedOutput[0][i][3];

  //       // Convert from center coordinates to top-left coordinates
  //       x = x - w / 2;
  //       y = y - h / 2;

  //       Rect boundingBox = Rect.fromLTWH(x, y, w, h);
  //       detections.add(Detection(boundingBox, _labels![classIndex], maxScore));
  //     }
  //   }

  //   // Perform Non-Maximum Suppression
  //   List<Detection> nmsDetections =
  //       _nonMaxSuppression(detections, IOU_THRESHOLD);

  //   if (nmsDetections.isEmpty) return [];

  //   for (var detection in nmsDetections) {
  //     var newRect = imageProcessor!
  //         .inverseTransformRect(detection.location, height, width);
  //     detection.location = newRect;
  //   }

  //   print(nmsDetections);
  //   return nmsDetections;
  // }

  List<Detection> _processOutput(
      List<List<List<double>>> output, int width, int height) {
    // Transpose the output from [1, 6, 8400] to [1, 8400, 6]
    List<List<List<double>>> transposedOutput = _transposeOutput(output);

    final int numPredictions = transposedOutput[0].length;
    final int numClasses =
        transposedOutput[0][0].length - 4; // Subtract 4 for x, y, w, h
// Prepare tensors for BoundingBoxUtils
    TensorBuffer outputLocations = TensorBuffer.createFixedSize(
        [1, numPredictions, 4], TfLiteType.float32);
    TensorBuffer outputClasses = TensorBuffer.createFixedSize(
        [1, numPredictions, numClasses], TfLiteType.float32);

    // Load data into TensorBuffers
    final locationsBuffer = outputLocations.getBuffer();
    final classesBuffer = outputClasses.getBuffer();

    for (int i = 0; i < numPredictions; i++) {
      for (int j = 0; j < 4; j++) {
        locationsBuffer.asFloat32List()[(i * 4) + j] =
            transposedOutput[0][i][j];
      }
      for (int j = 0; j < numClasses; j++) {
        classesBuffer.asFloat32List()[(i * numClasses) + j] =
            transposedOutput[0][i][j + 4];
      }
    }

    List<Rect> locations = BoundingBoxUtils.convert(
      tensor: outputLocations,
      valueIndex: [0, 1, 2, 3], // [y, x, h, w] to [x, y, w, h]
      boundingBoxAxis: 2,
      boundingBoxType: BoundingBoxType.CENTER,
      coordinateType: CoordinateType.RATIO,
      height: INPUT_SIZE,
      width: INPUT_SIZE,
    );

    List<Detection> detections = [];

    for (int i = 0; i < numPredictions; i++) {
      List<double> classScores = transposedOutput[0][i].sublist(4);
      double maxScore = classScores.reduce(max);
      if (maxScore >= CONFIDENCE_THRESHOLD) {
        int classIndex = classScores.indexOf(maxScore);

        // Scale the bounding box to the actual image size
        Rect scaledBox =
            imageProcessor!.inverseTransformRect(locations[i], height, width);

        detections.add(Detection(scaledBox, _labels![classIndex], maxScore));
      }
    }

    // Perform Non-Maximum Suppression
    List<Detection> nmsDetections =
        _nonMaxSuppression(detections, IOU_THRESHOLD);

    if (nmsDetections.isEmpty) return [];

    return nmsDetections;
  }

  List<List<List<double>>> _transposeOutput(List<List<List<double>>> output) {
    int dim1 = output.length;
    int dim2 = output[0].length;
    int dim3 = output[0][0].length;

    List<List<List<double>>> transposed = List.generate(
      dim1,
      (_) => List.generate(
        dim3,
        (_) => List<double>.filled(dim2, 0),
      ),
    );

    for (int i = 0; i < dim1; i++) {
      for (int j = 0; j < dim2; j++) {
        for (int k = 0; k < dim3; k++) {
          transposed[i][k][j] = output[i][j][k];
        }
      }
    }

    return transposed;
  }

  List<Detection> _nonMaxSuppression(
      List<Detection> detections, double iouThreshold) {
    detections.sort((a, b) => b.score.compareTo(a.score));
    List<Detection> nmsDetections = [];

    while (detections.isNotEmpty) {
      Detection current = detections.removeAt(0);
      nmsDetections.add(current);

      detections = detections.where((detection) {
        double iou = _calculateIoU(current.location, detection.location);
        return iou <= iouThreshold;
      }).toList();
    }

    return nmsDetections;
  }

  double _calculateIoU(Rect box1, Rect box2) {
    final intersectionRect = box1.intersect(box2);
    final intersectionArea = intersectionRect.width * intersectionRect.height;

    final box1Area = box1.width * box1.height;
    final box2Area = box2.width * box2.height;

    final unionArea = box1Area + box2Area - intersectionArea;

    return intersectionArea / unionArea;
  }

  List<List<List<double>>> castOutput(dynamic output) {
    if (output is List) {
      return output.map<List<List<double>>>((item) {
        if (item is List) {
          return item.map<List<double>>((subItem) {
            if (subItem is List) {
              return subItem.cast<double>();
            }
            return <double>[];
          }).toList();
        }
        return <List<double>>[];
      }).toList();
    }
    return <List<List<double>>>[];
  }

  /// Gets the interpreter instance
  Interpreter? get interpreter => _interpreter;

  /// Gets the loaded labels
  List<String>? get labels => _labels;
}
