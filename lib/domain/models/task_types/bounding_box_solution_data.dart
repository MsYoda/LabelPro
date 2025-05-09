import 'package:label_pro_client/domain/models/bounding_box.dart';

class BoundingBoxTaskResultData {
  final List<BoundingBox> boxes;

  const BoundingBoxTaskResultData({
    required this.boxes,
  });

  Map<String, dynamic> toJson() {
    return {
      'boxes': boxes.map((box) => box.toJson()).toList(),
    };
  }
}
