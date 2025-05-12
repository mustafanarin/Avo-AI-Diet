import 'package:avo_ai_diet/product/constants/project_colors.dart';
import 'package:avo_ai_diet/product/utility/extensions/text_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final class ProjectToastMessage {
  static void show(
    BuildContext context,
    String message, {
    int seconds = 2,
    bool isThereIcon = true,
    Color backGroundColor = ProjectColors.greenRYB,
  }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 100.h,
        left: 0,
        right: 0,
        child: SafeArea(
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: backGroundColor,
                  borderRadius: BorderRadius.circular(25.r),
                  boxShadow: [
                    BoxShadow(
                      color: ProjectColors.black.withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isThereIcon)
                      Icon(
                        Icons.local_fire_department,
                        color: ProjectColors.white,
                        size: 20.r,
                      )
                    else
                      const SizedBox.shrink(),
                    SizedBox(width: 8.w),
                    Text(
                      message,
                      style: context.textTheme().bodySmall?.copyWith(color: ProjectColors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Remove Toast after specified seconds
    Future.delayed(Duration(seconds: seconds), overlayEntry.remove);
  }
}
