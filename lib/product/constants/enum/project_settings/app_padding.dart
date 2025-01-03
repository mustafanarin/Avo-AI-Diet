import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum _PaddingValues {
  large(24),
  xMedium(20),
  medium(16),
  normal(12),
  small(8);

  const _PaddingValues(this.value);

  final int value;
}

final class AppPadding extends EdgeInsets {
  AppPadding.smallHorizontal() : super.symmetric(horizontal: _PaddingValues.small.value.w);
  AppPadding.mediumHorizontal() : super.symmetric(horizontal: _PaddingValues.medium.value.w);
  AppPadding.largeAll() : super.all(_PaddingValues.large.value.r);
  AppPadding.mediumAll() : super.all(_PaddingValues.medium.value.r);
  AppPadding.smallAll() : super.all(_PaddingValues.small.value.r);
  AppPadding.onlyTopXmedium() : super.only(top: _PaddingValues.xMedium.value.h);
  AppPadding.customSymmetricMediumSmall()
      : super.symmetric(horizontal: _PaddingValues.medium.value.w, vertical: _PaddingValues.small.value.r);
  AppPadding.customSymmetricMediumNormal()
      : super.symmetric(horizontal: _PaddingValues.medium.value.w, vertical: _PaddingValues.normal.value.r);
}
