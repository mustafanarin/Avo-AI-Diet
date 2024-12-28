import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum _PaddingValues {
  large(24),
  xMedium(20),
  small(8);

  const _PaddingValues(this.value);

  final int value;
}

final class AppPadding extends EdgeInsets {
  AppPadding.smallHorizontal() : super.symmetric(horizontal: _PaddingValues.small.value.w);
  AppPadding.largeAll() : super.all(_PaddingValues.large.value.r);
  AppPadding.onlyTopXmedium() : super.only(top: _PaddingValues.xMedium.value.h);
}
