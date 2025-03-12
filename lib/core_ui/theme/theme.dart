import 'package:flutter/material.dart';
import 'package:label_pro_client/core_ui/theme/app_colors.dart';

final theme = ThemeData.light().copyWith(
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.blue,
    onPrimary: AppColors.white,
    secondary: AppColors.orange1,
    onSecondary: AppColors.white,
    error: AppColors.red,
    onError: AppColors.blue,
    surface: AppColors.white,
    onSurface: AppColors.lagoonBlack,
  ),
);
