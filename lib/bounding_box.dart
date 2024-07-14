import 'dart:math';

import 'package:flutter/material.dart';

class BoundingBox {
  final Offset topLeft;
  final Offset bottomRight;

  BoundingBox({required this.topLeft, required this.bottomRight});

  Offset get center => Offset(
        (topLeft.dx + bottomRight.dx) / 2,
        (topLeft.dy + bottomRight.dy) / 2,
      );

  double get width => bottomRight.dx - topLeft.dx;
  double get height => bottomRight.dy - topLeft.dy;

  bool isInside(BoundingBox other) {
    return topLeft.dx >= other.topLeft.dx &&
        topLeft.dy >= other.topLeft.dy &&
        bottomRight.dx <= other.bottomRight.dx &&
        bottomRight.dy <= other.bottomRight.dy;
  }

  bool isTooLarge(BoundingBox other) {
    return width > other.width || height > other.height;
  }

  bool isTooSmall(BoundingBox other) {
    return width < other.width || height < other.height;
  }

  bool isMatch(BoundingBox other) {
    const double tolerance = 10.0;
    return isInside(other) &&
        width >= other.width - tolerance &&
        height >= other.height - tolerance;
  }
}

class BoundingBoxComparison extends StatefulWidget {
  const BoundingBoxComparison({super.key});

  @override
  BoundingBoxComparisonState createState() => BoundingBoxComparisonState();
}

class BoundingBoxComparisonState extends State<BoundingBoxComparison> {
  late BoundingBox box1;
  late BoundingBox box2;
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _initializeBoxes();
  }

  void _initializeBoxes() {
    box1 = BoundingBox(
      topLeft: const Offset(-100, -60),
      bottomRight: const Offset(100, 60),
    );

    _randomizeBox2();
  }

  void _randomizeBox2() {
    double dx = random.nextDouble() * 200 - 100;
    double dy = random.nextDouble() * 200 - 100;
    double width = 150 + random.nextDouble() * 80;
    double height = width * (60 / 100); // maintaining the same aspect ratio

    setState(() {
      box2 = BoundingBox(
        topLeft: Offset(dx - width / 2, dy - height / 2),
        bottomRight: Offset(dx + width / 2, dy + height / 2),
      );
    });
  }

  void _setDefaultBox2() {
    setState(() {
      box2 = BoundingBox(
        topLeft: const Offset(-97, -57),
        bottomRight: const Offset(97, 57),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Offset center1 = box1.center;
    Offset center2 = box2.center;

    String relativePosition = '';
    if (center2.dx > center1.dx && center2.dy > center1.dy) {
      relativePosition = 'KTP terlalu Kanan bawah';
    } else if (center2.dx > center1.dx && center2.dy < center1.dy) {
      relativePosition = 'KTP terlalu kanan atas';
    } else if (center2.dx < center1.dx && center2.dy > center1.dy) {
      relativePosition = 'KTP terlalu kiri bawah';
    } else if (center2.dx < center1.dx && center2.dy < center1.dy) {
      relativePosition = 'KTP terlalu kiri atas';
    } else if (center2.dx > center1.dx) {
      relativePosition = 'KTP terlalu kanan';
    } else if (center2.dx < center1.dx) {
      relativePosition = 'KTP terlalu kiri';
    } else if (center2.dy > center1.dy) {
      relativePosition = 'KTP terlalu bawah';
    } else if (center2.dy < center1.dy) {
      relativePosition = 'KTP terlalu atas';
    }

    String sizeInfo = '';
    if (box2.isMatch(box1)) {
      sizeInfo = 'KTP sudah pas';
    } else if (box2.isTooLarge(box1)) {
      sizeInfo = 'KTP terlalu dekat';
    } else if (box2.isTooSmall(box1)) {
      sizeInfo = 'KTP terlalu jauh';
    }

    return Center(
      child: Stack(
        children: [
          CustomPaint(
            size: const Size(double.infinity, double.infinity),
            painter: BoundingBoxPainter(box1, box2),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(relativePosition,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                Text(sizeInfo,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _randomizeBox2,
                  child: const Text('Randomize KTP Position'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _setDefaultBox2,
                  child: const Text('Default KTP Position'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BoundingBoxPainter extends CustomPainter {
  final BoundingBox box1;
  final BoundingBox box2;

  BoundingBoxPainter(this.box1, this.box2);

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final paint2 = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    canvas.drawRect(
      Rect.fromPoints(
        Offset(centerX + box1.topLeft.dx, centerY + box1.topLeft.dy),
        Offset(centerX + box1.bottomRight.dx, centerY + box1.bottomRight.dy),
      ),
      paint1,
    );

    canvas.drawRect(
      Rect.fromPoints(
        Offset(centerX + box2.topLeft.dx, centerY + box2.topLeft.dy),
        Offset(centerX + box2.bottomRight.dx, centerY + box2.bottomRight.dy),
      ),
      paint2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
