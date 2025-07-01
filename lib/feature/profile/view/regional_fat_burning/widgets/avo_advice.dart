part of '../regional_fat_burning.dart';


class _AvoAdvice extends StatelessWidget {
  final String advice;
  const _AvoAdvice(
    this.advice,
  ) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ProjectColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ProjectColors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: ProjectColors.primary,
                radius: 16.r,
                child: Icon(
                  Icons.local_fire_department_outlined,
                  color: ProjectColors.white,
                  size: 18.w,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                ProjectStrings.advicesOfAvo,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: ProjectColors.darkAvocado,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          MarkdownBody(
            data: advice,
            styleSheet: MarkdownStyleSheet(
              p: const TextStyle(
                color: ProjectColors.black,
              ),
              strong: const TextStyle(
                fontWeight: FontWeight.bold,
                color: ProjectColors.black,
              ),
              em: const TextStyle(
                fontStyle: FontStyle.italic,
                color: ProjectColors.black,
              ),
              listBullet: const TextStyle(
                color: ProjectColors.black,
              ),
            ),
            selectable: true,
          ),
        ],
      ),
    );
  }
}
