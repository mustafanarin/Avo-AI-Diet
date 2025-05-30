import 'package:avo_ai_diet/feature/onboarding/cubit/name_and_cal_cubit.dart';
import 'package:avo_ai_diet/feature/onboarding/state/name_and_cal_state.dart';
import 'package:avo_ai_diet/feature/profile/cubit/water_reminder_cubit.dart';
import 'package:avo_ai_diet/feature/profile/state/water_reminder_state.dart';
import 'package:avo_ai_diet/product/constants/project_colors.dart';
import 'package:avo_ai_diet/product/constants/project_strings.dart';
import 'package:avo_ai_diet/product/constants/route_names.dart';
import 'package:avo_ai_diet/product/utility/extensions/text_theme_extension.dart';
import 'package:avo_ai_diet/product/utility/init/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

final class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<WaterReminderCubit>(
      create: (context) => getIt<WaterReminderCubit>(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            ProjectStrings.myProfile,
            style: context.textTheme().titleLarge,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20.h),
              const ProfileHeader(),
              SizedBox(height: 30.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: _ProfileItems(
                  onNameEditTap: () {
                    context.push(RouteNames.nameEdit);
                  },
                  onUserInfoEditTap: () {
                    context.push(RouteNames.userInfoEdit);
                  },
                  onRegionalBodyTap: () {
                    context.push(RouteNames.regionalFat);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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

class _ProfileItemWidget extends StatelessWidget {
  const _ProfileItemWidget({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(20.r),
        onTap: onTap,
        splashColor: ProjectColors.apple.withValues(alpha: 0.2),
        highlightColor: ProjectColors.apple.withValues(alpha: 0.1),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  color: ProjectColors.apple,
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 30.w,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.textTheme().titleMedium?.copyWith(color: ProjectColors.laurel),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: context
                          .textTheme()
                          .bodySmall
                          ?.copyWith(color: ProjectColors.earthBrown.withValues(alpha: 0.8)),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 26.w,
                color: ProjectColors.laurel,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SwitchItemWidget extends StatelessWidget {
  const _SwitchItemWidget({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
  });
  final String title;
  final String subtitle;
  final IconData icon;
  final bool value;
  final void Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ProjectColors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: ProjectColors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              color: ProjectColors.apple,
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Icon(
              icon,
              color: ProjectColors.white,
              size: 30.w,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: ProjectColors.laurel,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style:
                      context.textTheme().bodySmall?.copyWith(color: ProjectColors.earthBrown.withValues(alpha: 0.8)),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: ProjectColors.mayGreen,
            activeTrackColor: ProjectColors.dolarBill,
          ),
        ],
      ),
    );
  }
}

class _WaterReminderSwitchItem extends StatelessWidget {
  const _WaterReminderSwitchItem();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WaterReminderCubit, WaterReminderState>(
      builder: (context, state) {
        return Column(
          children: [
            _SwitchItemWidget(
              title: ProjectStrings.waterReminder,
              subtitle: ProjectStrings.reminderSupTitle,
              icon: Icons.water_drop_outlined,
              value: state.isEnabled,
              onChanged: (value) {
                context.read<WaterReminderCubit>().toggleWaterReminder(value);
              },
            ),

            // TODObildirim önizleme
            // if (state.isEnabled)
            //   Padding(
            //     padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            //     child: ElevatedButton(
            //       onPressed: () {
            //         // Önizleme bildirimini göster
            //         context.read<WaterReminderCubit>().showPreviewNotification();
            //       },
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: ProjectColors.apple,
            //         foregroundColor: Colors.white,
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(15.r),
            //         ),
            //         padding: EdgeInsets.symmetric(vertical: 12.h),
            //       ),
            //       child: Text(
            //         'Bildirim Önizlemesi',
            //         style: TextStyle(
            //           fontSize: 16.sp,
            //           fontWeight: FontWeight.w600,
            //         ),
            //       ),
            //     ),
            //   ),
          ],
        );
      },
    );
  }
}

class _ProfileItems extends StatelessWidget {
  const _ProfileItems({
    required this.onNameEditTap,
    required this.onUserInfoEditTap,
    required this.onRegionalBodyTap,
  });
  final VoidCallback onNameEditTap;
  final VoidCallback onUserInfoEditTap;
  final VoidCallback onRegionalBodyTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ProfileItemWidget(
          title: ProjectStrings.changeName,
          subtitle: ProjectStrings.changeNameSupTitle,
          icon: Icons.person_outline,
          onTap: onNameEditTap,
        ),
        SizedBox(height: 16.h),
        _ProfileItemWidget(
          title: ProjectStrings.bodyInformation,
          subtitle: ProjectStrings.bodyInformationSupTitle,
          icon: Icons.accessibility_new_outlined,
          onTap: onUserInfoEditTap,
        ),
        SizedBox(height: 16.h),
        _ProfileItemWidget(
          title: ProjectStrings.regionalFatBurning,
          subtitle: ProjectStrings.fatBurningSupTitle,
          icon: Icons.local_fire_department_outlined,
          onTap: onRegionalBodyTap,
        ),
        SizedBox(height: 16.h),
        const _WaterReminderSwitchItem(),
        SizedBox(height: 30.h),
      ],
    );
  }
}
