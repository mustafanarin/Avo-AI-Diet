import 'package:avo_ai_diet/product/constants/project_colors.dart';
import 'package:avo_ai_diet/product/utility/extensions/text_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final class ProjectToastMessage {
  // is toast showing?
  static bool _isShowing = false;

  static void show(
    BuildContext context,
    String message, {
    int seconds = 2,
    bool isThereIcon = true,
    Color backGroundColor = ProjectColors.greenRYB,
  }) {
    // Context mounted kontrolü
    if (!_isContextValid(context)) {
      return;
    }

    if (_isShowing) {
      return;
    }

    // Toast started showing
    _isShowing = true;

    final overlay = Overlay.of(context);
    late final OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
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
                    Flexible(
                      child: Text(
                        message,
                        style: context.textTheme().bodySmall?.copyWith(
                              color: ProjectColors.white,
                              fontWeight: FontWeight.w500,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    try {
      overlay.insert(overlayEntry);

      // Remove toast after duration
      Future.delayed(Duration(seconds: seconds), () {
        _safeRemoveOverlay(overlayEntry);
      });
    } catch (e) {
      // Overlay insert failed
      debugPrint('ProjectToast: Failed to insert overlay - $e');
      // reset
      _isShowing = false;
    }
  }

  // Context validity check
  static bool _isContextValid(BuildContext context) {
    try {
      return context.mounted && Overlay.maybeOf(context) != null;
    } catch (e) {
      return false;
    }
  }

  // Safe overlay removal
  static void _safeRemoveOverlay(OverlayEntry overlayEntry) {
    try {
      overlayEntry.remove();
    } catch (e) {
      debugPrint('ProjectToast: Safe removal failed - $e');
    } finally {
      // 🆕 Toast removed
      _isShowing = false;
    }
  }

  // Convenience methods
  static void showSuccess(BuildContext context, String message) {
    if (!_isContextValid(context)) return;

    show(
      context,
      message,
    );
  }

  static void showError(BuildContext context, String message) {
    if (!_isContextValid(context)) return;

    show(
      context,
      message,
      seconds: 4,
      backGroundColor: ProjectColors.accentCoral,
    );
  }

  static void showWarning(BuildContext context, String message) {
    if (!_isContextValid(context)) return;

    show(
      context,
      message,
      seconds: 3,
      backGroundColor: ProjectColors.sandyBrown,
    );
  }

  static void showInfo(BuildContext context, String message) {
    if (!_isContextValid(context)) return;

    show(
      context,
      message,
      seconds: 3,
      backGroundColor: ProjectColors.primary,
    );
  }
}
