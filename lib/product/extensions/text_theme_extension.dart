import 'package:flutter/material.dart' show BuildContext, TextTheme, Theme;

extension TextThemeExtension on BuildContext{
  TextTheme textTheme() {
    return Theme.of(this).textTheme;
  }
}