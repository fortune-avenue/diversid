import 'package:diversid/src/core/presentation/ktp/models/detection.dart';
import 'package:flutter/material.dart';

/// Individual bounding box
class BoundingBoxWidget extends StatelessWidget {
  final Detection result;

  const BoundingBoxWidget({Key? key, required this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Color for bounding box
    Color color = Colors.primaries[
        (result.label.length + result.label.codeUnitAt(0)) %
            Colors.primaries.length];

    return Positioned(
      left: result.renderLocation.left,
      top: result.renderLocation.top,
      width: result.renderLocation.width,
      height: result.renderLocation.height,
      child: Container(
        width: result.renderLocation.width,
        height: result.renderLocation.height,
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 3),
          borderRadius: const BorderRadius.all(Radius.circular(2)),
        ),
        child: Align(
          alignment: Alignment.topLeft,
          child: FittedBox(
            child: Container(
              color: color,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(result.label, style: TextStyle(color: Colors.white)),
                  SizedBox(width: 4),
                  Text(result.score.toStringAsFixed(2),
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
