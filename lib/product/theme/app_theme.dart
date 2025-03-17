import 'package:avo_ai_diet/product/constants/project_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract final class AppTheme {
  static ThemeData get getLightTheme => ThemeData.light().copyWith(
        scaffoldBackgroundColor: ProjectColors.backgroundCream,
        appBarTheme: AppBarTheme(
          titleTextStyle: _ProjectTextStyle.titlelarge,
          systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          scrolledUnderElevation: 0,
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
        textTheme:  TextTheme(
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
  static final TextStyle displayLarge = TextStyle(
    // for welcome view title
    fontFamily: 'Inter',
    fontSize: 28.sp,
    fontWeight: FontWeight.bold,
    color: ProjectColors.forestGreen,
  );

  static final displayMedium = TextStyle(
    // for suptitle
    fontFamily: 'Inter',
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    color: ProjectColors.darkAvocado,
    letterSpacing: -0.3,
  );

  static final titlelarge = TextStyle(
    // for appbar title
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: ProjectColors.earthBrown,
    letterSpacing: 0.5,
  );

  static final titleMedium = TextStyle(
    // for normal title with forestGreen
    fontSize: 17.sp,
    fontWeight: FontWeight.w600,
    color: ProjectColors.forestGreen,
    letterSpacing: 0.5,
  );

  static final bodyLarge = TextStyle(
    // large texts
    fontFamily: 'Inter',
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: ProjectColors.darkAvocado,
  );

  static final bodyMedium = TextStyle(
    // for normal text and form labels
    fontFamily: 'Inter',
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: ProjectColors.earthBrown,
  );

  static final bodySmall = TextStyle(
    // for small texts and descriptions
    fontFamily: 'Inter',
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: ProjectColors.earthBrown,
  );

  static final buttonText = TextStyle(
    // for button text
    fontFamily: 'Inter',
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: ProjectColors.white,
  );
}
