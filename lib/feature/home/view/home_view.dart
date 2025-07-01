import 'package:avo_ai_diet/feature/home/cubit/ai_diet_advice_cubit.dart';
import 'package:avo_ai_diet/feature/home/cubit/daily_calorie_cubit.dart';
import 'package:avo_ai_diet/feature/home/state/ai_diet_advice_state.dart';
import 'package:avo_ai_diet/feature/home/state/daily_calorie_state.dart';
import 'package:avo_ai_diet/feature/onboarding/cubit/name_and_cal_cubit.dart';
import 'package:avo_ai_diet/feature/onboarding/state/name_and_cal_state.dart';
import 'package:avo_ai_diet/product/cache/model/response/ai_response.dart';
import 'package:avo_ai_diet/product/constants/enum/custom/hero_lottie_enum.dart';
import 'package:avo_ai_diet/product/constants/enum/general/json_name.dart';
import 'package:avo_ai_diet/product/constants/enum/general/png_name.dart';
import 'package:avo_ai_diet/product/constants/enum/project_settings/app_durations.dart';
import 'package:avo_ai_diet/product/constants/enum/project_settings/app_padding.dart';
import 'package:avo_ai_diet/product/constants/enum/project_settings/app_radius.dart';
import 'package:avo_ai_diet/product/constants/project_colors.dart';
import 'package:avo_ai_diet/product/constants/project_strings.dart';
import 'package:avo_ai_diet/product/constants/route_names.dart';
import 'package:avo_ai_diet/product/utility/extensions/json_extension.dart';
import 'package:avo_ai_diet/product/utility/extensions/png_extension.dart';
import 'package:avo_ai_diet/product/utility/extensions/text_theme_extension.dart';
import 'package:avo_ai_diet/product/utility/mixin/error_handle_mixin.dart';
import 'package:avo_ai_diet/product/widgets/project_button.dart';
import 'package:avo_ai_diet/product/widgets/project_toast_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

part './widgets/appbar.dart';
part './widgets/calorie_follow_indicator.dart';
part './widgets/card_diet.dart';
part './widgets/error_diet_widget.dart';
part './widgets/loading_widget.dart';
part './widgets/mini_adjust_button.dart';
part './widgets/success_diet_card.dart';

final class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with AiErrorHandlerMixin {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NameAndCalCubit, NameAndCalState>(
      builder: (context, nameCalState) {
        final targetCalories = nameCalState.targetCal ?? 2500;
        return Scaffold(
          appBar: _CustomAppBar(name: nameCalState.name),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: AppPadding.mediumHorizontal(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _CalorieFollowIndicator(maxCalories: targetCalories),
                      SizedBox(height: 20.h),
                      Text(ProjectStrings.myDietList, style: context.textTheme().bodyLarge),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                const Expanded(
                  child: _ModernDietCard(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
