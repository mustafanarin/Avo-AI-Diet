part of '../favorite_view.dart';

void _showFullText(BuildContext context, String text) {
  showDialog<void>(
    context: context,
    builder: (dialogContext) => HookBuilder(
      builder: (hookContext) {
        final showTopShadow = useState(false);
        final textTheme = hookContext.textTheme();

        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Container(
            constraints: BoxConstraints(maxHeight: 500.h),
            decoration: BoxDecoration(
              color: ProjectColors.backgroundCream,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: ProjectColors.darkAvocado.withValues(alpha: 0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        ProjectColors.lightAvocado.withValues(alpha: 0.9),
                        ProjectColors.accentCoral.withValues(alpha: 0.8),
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.menu_book_rounded,
                        color: ProjectColors.white,
                        size: 24.r,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        ProjectStrings.details,
                        style: textTheme.titleMedium?.copyWith(
                          color: ProjectColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        icon: Icon(
                          Icons.close_rounded,
                          color: ProjectColors.white,
                          size: 24.r,
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Stack(
                    children: [
                      NotificationListener<ScrollNotification>(
                        onNotification: (scrollNotification) {
                          final shouldShowShadow = scrollNotification.metrics.pixels > 10;
                          if (showTopShadow.value != shouldShowShadow) {
                            showTopShadow.value = shouldShowShadow;
                          }
                          return true;
                        },
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          child: SingleChildScrollView(
                            physics: const ClampingScrollPhysics(),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 20.h),
                              child: Markdown(
                                data: text,
                                styleSheet: MarkdownStyleSheet(
                                  p: textTheme.bodyMedium?.copyWith(
                                    fontSize: 16.sp,
                                    height: 1.5,
                                  ),
                                  strong: textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                    height: 1.5,
                                  ),
                                  em: textTheme.bodyMedium?.copyWith(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 16.sp,
                                    height: 1.5,
                                  ),
                                  listBullet: textTheme.bodyMedium?.copyWith(
                                    color: ProjectColors.forestGreen,
                                    fontSize: 16.sp,
                                  ),
                                  h1: textTheme.titleLarge?.copyWith(
                                    color: ProjectColors.darkAvocado,
                                    fontSize: 20.sp,
                                  ),
                                  h2: textTheme.titleMedium?.copyWith(
                                    color: ProjectColors.forestGreen,
                                    fontSize: 18.sp,
                                  ),
                                ),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: AnimatedOpacity(
                          opacity: showTopShadow.value ? 1.0 : 0.0,
                          duration: AppDurations.smallMilliseconds(),
                          child: Container(
                            height: 24,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  ProjectColors.black.withValues(alpha: 0.15),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}