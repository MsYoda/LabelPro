import 'package:flutter/cupertino.dart';
import 'package:label_pro_client/features/tagging/tasks/bounding_box/utils/bounding_box_utils.dart';

extension RectExt on Rect {
  Rect get withCorrectCorners {
    double left = this.left;
    double top = this.top;
    double right = this.right;
    double bottom = this.bottom;

    if (left > right) {
      double temp = left;
      left = right;
      right = temp;
    }

    if (top > bottom) {
      double temp = top;
      top = bottom;
      bottom = temp;
    }

    return Rect.fromLTRB(left, top, right, bottom);
  }

  Rect clamped(BoxConstraints constraints) {
    return getClampedRect(topLeft, bottomRight, constraints);
  }
}
