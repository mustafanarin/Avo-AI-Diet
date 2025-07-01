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

part './widgets/profile_header.dart';
part './widgets/profile_items.dart';
part './widgets/water_reminder.dart';

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
