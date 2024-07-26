import 'dart:ui';

/// Singleton to record size related data
class CameraViewSingleton {
  static double ratio = 1.0;
  static Size screenSize = Size(1.0, 1.0);
  static Size inputImageSize = Size(1.0, 1.0);

  /// Provides the actual preview size based on the screen size and aspect ratio
  static Size get actualPreviewSize =>
      Size(screenSize.width, screenSize.width * ratio);
}
