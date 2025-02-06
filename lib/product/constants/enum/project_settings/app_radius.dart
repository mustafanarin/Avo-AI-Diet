import 'package:flutter/material.dart' show BorderRadius, Radius;
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum _RadiusValues {
  large(40),
  medium(28),
  small(16),
  xSmall(8);

  const _RadiusValues(this.value);

  final double value;
}

final class AppRadius extends BorderRadius {
  AppRadius.circularMedium() : super.circular(_RadiusValues.medium.value.r);
  AppRadius.circularSmall() : super.circular(_RadiusValues.small.value.r);
  AppRadius.circularxSmall() : super.circular(_RadiusValues.xSmall.value.r);
  AppRadius.onlyTopSmall()
      : super.only(
          topRight: Radius.circular(
            _RadiusValues.small.value.r,
          ),
          topLeft: Radius.circular(_RadiusValues.small.value.r),
        );
  AppRadius.topLargeRadius()
      : super.vertical(
          top: Radius.circular(_RadiusValues.large.value.r),
        );
}
