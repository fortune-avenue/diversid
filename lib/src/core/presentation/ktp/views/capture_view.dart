import 'dart:io';
import 'package:flutter/material.dart';

class CaptureView extends StatelessWidget {
  final String imagePath;

  CaptureView({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Captured Image'),
      ),
      body: Center(
        child: imagePath.isNotEmpty
            ? Image.file(File(imagePath))
            : Text('No image captured'),
      ),
    );
  }
}
