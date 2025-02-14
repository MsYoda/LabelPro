import 'dart:ui';

import 'label.dart';

class BoundingBox {
  final Rect box;
  final Label label;

  const BoundingBox({
    required this.box,
    required this.label,
  });

  BoundingBox copyWith({
    Rect? box,
    Label? label,
  }) {
    return BoundingBox(
      box: box ?? this.box,
      label: label ?? this.label,
    );
  }
}
