import 'dart:ui';

import 'label.dart';

class Polygon {
  final Rect box;
  final Label label;

  const Polygon({
    required this.box,
    required this.label,
  });

  Polygon copyWith({
    Rect? box,
    Label? label,
  }) {
    return Polygon(
      box: box ?? this.box,
      label: label ?? this.label,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'box': {
        'left': box.left,
        'top': box.top,
        'right': box.right,
        'bottom': box.bottom,
      },
      'label': label.toJson(),
    };
  }
}
