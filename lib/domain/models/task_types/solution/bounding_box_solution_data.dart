import 'package:label_pro_client/domain/models/bounding_box.dart';

class BoundingBoxSolutionData {
  final String filePath;
  final List<BoundingBox> boxes;

  const BoundingBoxSolutionData({
    required this.filePath,
    required this.boxes,
  });
}
