import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';

class BoundingBoxTaskData {
  final Uint8List image;
  final String filePath;
  final double imageWidth;
  final double imageHeight;

  const BoundingBoxTaskData({
    required this.image,
    required this.filePath,
    required this.imageHeight,
    required this.imageWidth,
  });
}
