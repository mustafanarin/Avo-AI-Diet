
part of '../home_view.dart';


class _LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Avo loading animation
          Lottie.asset(
            JsonName.avoWalk.path,
            height: 120.h,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 24.h),

          SizedBox(
            width: 40.w,
            height: 40.h,
            child: const CircularProgressIndicator(
              color: ProjectColors.primary,
              strokeWidth: 3,
            ),
          ),

          SizedBox(height: 16.h),

          Text(
            'Avo diyet planınızı kontrol ediyor...',
            style: context.textTheme().bodyMedium?.copyWith(
                  color: ProjectColors.grey600,
                ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 8.h),

          Text(
            'Bu işlem birkaç saniye sürebilir',
            style: context.textTheme().bodySmall?.copyWith(
                  color: ProjectColors.grey500,
                  fontStyle: FontStyle.italic,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}