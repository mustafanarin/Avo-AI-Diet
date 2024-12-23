import 'package:avo_ai_diet/product/constants/project_colors.dart';
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static ThemeData get getLightTheme => ThemeData.light().copyWith(

        textTheme: const TextTheme(
          displayLarge: _ProjectTextStyle.heading1,
          displayMedium: _ProjectTextStyle.heading2,
          bodyLarge: _ProjectTextStyle.bodyLarge,
          bodyMedium: _ProjectTextStyle.bodyMedium,
          bodySmall: _ProjectTextStyle.bodySmall,
          labelLarge: _ProjectTextStyle.buttonText,
        ),
      );
}

class _ProjectTextStyle {
  static const heading1 = TextStyle(
    // for welcome view title
    fontFamily: 'Inter',
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: ProjectColors.darkAvocado,
    letterSpacing: -0.5,
  );

  static const heading2 = TextStyle(
    // for suptitle
    fontFamily: 'Inter',
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: ProjectColors.darkAvocado,
    letterSpacing: -0.3,
  );

  static const bodyLarge = TextStyle(
    // for appbar and large texts
    fontFamily: 'Inter',
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: ProjectColors.darkAvocado,
  );

  static const bodyMedium = TextStyle(
    // for normal text and form labels
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: ProjectColors.earthBrown,
  );

  static const bodySmall = TextStyle(
    // for small texts and descriptions
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: ProjectColors.earthBrown,
  );

  static const buttonText = TextStyle(
    // for button text
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: ProjectColors.backgroundCream,
  );
}
