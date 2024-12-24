import 'package:flutter/material.dart' show BorderRadius, Radius;
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum _RadiusValues {
  large(40);

  const _RadiusValues(this.value);

  final double value;
}

final class AppRadius extends BorderRadius {
  AppRadius.topLargeRadius() : super.vertical(
    top: Radius.circular(_RadiusValues.large.value.r),);
  
}
