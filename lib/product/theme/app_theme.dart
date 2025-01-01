import 'package:avo_ai_diet/product/constants/project_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract final class AppTheme {
  static ThemeData get getLightTheme => ThemeData.light().copyWith(
        scaffoldBackgroundColor: ProjectColors.backgroundCream,
        appBarTheme: const AppBarTheme(
          titleTextStyle: _ProjectTextStyle.titlelarge,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
        ),
        inputDecorationTheme: InputDecorationTheme(
          floatingLabelStyle: _ProjectTextStyle.bodyMedium.copyWith(
            color: ProjectColors.forestGreen,
            fontSize: 16,
          ),
          suffixStyle: _ProjectTextStyle.bodyMedium.copyWith(
            color: ProjectColors.forestGreen,
            fontSize: 16,
          ),
          errorStyle: _ProjectTextStyle.bodySmall.copyWith(
            color: ProjectColors.red,
          ),
          labelStyle: _ProjectTextStyle.bodyMedium.copyWith(
            color: Colors.grey.shade600,
          ),
          hintStyle: _ProjectTextStyle.bodyMedium.copyWith(
            color: ProjectColors.grey600,
          ),
        ),
        colorScheme: const ColorScheme.light(
          primary: ProjectColors.forestGreen,
        ),
        textTheme: const TextTheme(
          displayLarge: _ProjectTextStyle.displayLarge,
          displayMedium: _ProjectTextStyle.displayMedium,
          bodyLarge: _ProjectTextStyle.bodyLarge,
          bodyMedium: _ProjectTextStyle.bodyMedium,
          bodySmall: _ProjectTextStyle.bodySmall,
          labelLarge: _ProjectTextStyle.buttonText,
          titleLarge: _ProjectTextStyle.titlelarge,
          titleMedium: _ProjectTextStyle.titleMedium,
        ),
      );
}

class _ProjectTextStyle {
  static const displayLarge = TextStyle(
    // for welcome view title
    fontFamily: 'Inter',
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: ProjectColors.forestGreen,
  );

  static const displayMedium = TextStyle(
    // for suptitle
    fontFamily: 'Inter',
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: ProjectColors.darkAvocado,
    letterSpacing: -0.3,
  );

  static const titlelarge = TextStyle(
    // for appbar title
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: ProjectColors.earthBrown,
    letterSpacing: 0.5,
  );

  static const titleMedium = TextStyle(
    // for normal title with forestGreen
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: ProjectColors.forestGreen,
    letterSpacing: 0.5,
  );

  static const bodyLarge = TextStyle(
    // large texts
    fontFamily: 'Inter',
    fontSize: 18,
    fontWeight: FontWeight.w600,
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
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: ProjectColors.white,
  );
}
