import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:label_pro_client/domain/models/label.dart';

import '../../../../../core_ui/theme/app_colors.dart';

Color getPolygonColor({
  required List<Label> avalibleLabels,
  required Label currentLabel,
}) {
  Color color = Colors.pink;
  avalibleLabels.asMap().forEach(
    (key, value) {
      if (value.id == currentLabel.id) {
        color = AppColors.accentColorFromIndex(key);
      }
    },
  );
  return color;
}
