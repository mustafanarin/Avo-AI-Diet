part of '../home_view.dart';

class _MiniAdjustButton extends StatelessWidget {
  const _MiniAdjustButton({
    required this.text,
    required this.textColor,
    required this.onPressed,
  });

  final String text;
  final Color textColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(6.r),
        child: Container(
          width: 40.w,
          height: 24.h,
          decoration: BoxDecoration(
            color: textColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6.r),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
