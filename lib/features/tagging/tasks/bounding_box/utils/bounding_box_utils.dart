import 'package:flutter/cupertino.dart';

Rect getClampedRect(Offset start, Offset end, BoxConstraints constraints) {
  final double left = start.dx.clamp(0, constraints.maxWidth);
  final double top = start.dy.clamp(0, constraints.maxHeight);
  final double right = end.dx.clamp(0, constraints.maxWidth);
  final double bottom = end.dy.clamp(0, constraints.maxHeight);

  return Rect.fromLTRB(left, top, right, bottom);
}
