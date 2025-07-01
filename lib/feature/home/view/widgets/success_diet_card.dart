part of '../home_view.dart';

// Success Widget(User Diet List)
class _SuccessDietCard extends StatelessWidget {
  const _SuccessDietCard({required this.response});

  final AiResponse response;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme();

    return Container(
      margin: AppPadding.customSymmetricMediumSmall(),
      decoration: BoxDecoration(
        color: ProjectColors.white.withValues(alpha: 0.6),
        borderRadius: AppRadius.circularSmall(),
        border: Border.all(color: ProjectColors.secondary.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          Container(
            padding: AppPadding.customSymmetricMediumNormal(),
            decoration: BoxDecoration(
              color: ProjectColors.backgroundCream,
              borderRadius: AppRadius.onlyTopSmall(),
            ),
            child: Row(
              children: [
                Container(
                  padding: AppPadding.smallAll(),
                  decoration: BoxDecoration(
                    color: ProjectColors.primary.withValues(alpha: 0.1),
                    borderRadius: AppRadius.circularxSmall(),
                  ),
                  child: Icon(
                    Icons.restaurant_rounded,
                    color: ProjectColors.primary,
                    size: 18.r,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ProjectStrings.dietListTitle,
                        style: textTheme.titleMedium?.copyWith(color: ProjectColors.primary),
                      ),
                      Text(
                        response.formattedDayMonthYear,
                        style: textTheme.bodySmall?.copyWith(
                          fontSize: 13.sp,
                          color: ProjectColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Markdown(
              data: response.dietPlan,
              styleSheet: MarkdownStyleSheet(
                p: textTheme.bodySmall?.copyWith(fontSize: 16.sp),
                strong: textTheme.bodySmall?.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
                em: textTheme.bodySmall?.copyWith(
                  fontSize: 16.sp,
                  fontStyle: FontStyle.italic,
                ),
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
            ),
          ),
        ],
      ),
    );
  }
}
