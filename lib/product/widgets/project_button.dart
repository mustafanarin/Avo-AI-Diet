import 'package:avo_ai_diet/product/constants/enum/project_settings/app_radius.dart';
import 'package:avo_ai_diet/product/constants/project_colors.dart';
import 'package:avo_ai_diet/product/utility/extensions/text_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final class ProjectButton extends StatelessWidget {
  const ProjectButton({
    required this.text,
    required this.onPressed,
    super.key,
    this.isEnabled = true,
  });
  final String text;
  final VoidCallback? onPressed;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56.h,
      decoration: _boxDecoration(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          borderRadius: AppRadius.circularSmall(),
          splashColor: ProjectColors.white.withValues(alpha: 0.2),
          child: Center(
            child: Text(
              text,
              style: context.textTheme().labelLarge,
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      borderRadius: AppRadius.circularSmall(),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          if (isEnabled) ProjectColors.lightGreen else ProjectColors.grey400,
          if (isEnabled) ProjectColors.darkGreen else ProjectColors.grey500,
        ],
      ),
      boxShadow: [
        BoxShadow(
          color: isEnabled ? ProjectColors.darkGreen.withValues(alpha: 0.3) : ProjectColors.grey.withValues(alpha: 0.3),
          offset: const Offset(0, 4),
          blurRadius: 12,
        ),
      ],
    );
  }
}
