import 'dart:ui';

import 'package:label_pro_client/domain/models/label.dart';

class Polygon {
  final List<Offset> points;
  final Label label;

  const Polygon({
    required this.points,
    required this.label,
  });

  Map<String, dynamic> toJson() {
    return {
      'points': points.map((e) => {'x': e.dx, 'y': e.dy}).toList(),
      'label': label.toJson(),
    };
  }
}
