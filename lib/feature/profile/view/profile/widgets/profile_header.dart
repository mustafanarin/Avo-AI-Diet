part of '../profile_view.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 130.w,
          height: 130.w,
          decoration: const BoxDecoration(
            color: ProjectColors.greenRYB,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              Icons.eco, // TODOAPP icon or AVO - isim uzunluk kontrol
              size: 70.w,
              color: ProjectColors.white,
            ),
          ),
        ),
        SizedBox(height: 24.h),
        BlocSelector<NameAndCalCubit, NameAndCalState, String?>(
          selector: (state) => state.name,
          builder: (context, name) {
            return Text(
              '${ProjectStrings.helloProfile} $name!',
              style: context.textTheme().displayLarge?.copyWith(
                    color: ProjectColors.laurel,
                  ),
            );
          },
        ),
        SizedBox(height: 8.h),
        Text(
          ProjectStrings.profileSupTitle,
          style: context.textTheme().bodyMedium,
        ),
        SizedBox(height: 16.h),
        Container(
          width: 160.w,
          height: 3.h,
          decoration: BoxDecoration(
            color: ProjectColors.greenRYB,
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      ],
    );
  }
}