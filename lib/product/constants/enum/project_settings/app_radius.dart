import 'package:flutter/material.dart' show BorderRadius, Radius;
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum _RadiusValues {
  large(40),
  medium(28),
  small(16);

  const _RadiusValues(this.value);

  final double value;
}

final class AppRadius extends BorderRadius {
  AppRadius.topLargeRadius()
      : super.vertical(
          top: Radius.circular(_RadiusValues.large.value.r),
        );
  AppRadius.circularMedium() : super.circular(_RadiusValues.medium.value.r);
  AppRadius.circularSmall() : super.circular(_RadiusValues.small.value.r);
}
