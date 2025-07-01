part of '../home_view.dart';
class _ErrorDietWidget extends StatelessWidget {
  const _ErrorDietWidget({
    required this.errorMessage,
    required this.onCreateNew,
  });

  final String errorMessage;
  final VoidCallback onCreateNew;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400.h,
      padding: AppPadding.mediumAll(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Error icon with Avo
          Image.asset(
            PngName.noSearchAvo.path,
            height: 150.h,
          ),

          SizedBox(height: 24.h),

          Text(
            '🥑 Diyet planı yüklenemedi',
            style: context.textTheme().headlineSmall?.copyWith(
                  color: ProjectColors.sandyBrown,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12.h),
          Text(
            errorMessage,
            style: context.textTheme().bodyMedium,
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 32.h),

          SizedBox(
            width: 300.w,
            child: ProjectButton(text: '✚ Yeni Diyet Planı Oluştur', onPressed: onCreateNew),
          ),
        ],
      ),
    );
  }
}
  