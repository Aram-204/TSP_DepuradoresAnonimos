import 'package:flutter/material.dart';
import 'package:ninerapp/util/app_colors.dart';

class AppShadows {
  static const BoxShadow indexBoxShadow = BoxShadow(
    color: AppColors.shadowColor,
    spreadRadius: 0.25,
    blurRadius: 4,
    offset: Offset(0, 6)
  );
}