import 'package:flutter/material.dart' show BuildContext, TextTheme, Theme;

extension BuildContextExtension on BuildContext{
  TextTheme textTheme() {
    return Theme.of(this).textTheme;
  }
}