import 'package:avo_ai_diet/feature/home/cubit/ai_diet_advice_cubit.dart';
import 'package:avo_ai_diet/feature/home/cubit/daily_calorie_cubit.dart';
import 'package:avo_ai_diet/feature/home/state/ai_diet_advice_state.dart';
import 'package:avo_ai_diet/feature/home/state/daily_calorie_state.dart';
import 'package:avo_ai_diet/feature/onboarding/cubit/name_and_cal_cubit.dart';
import 'package:avo_ai_diet/feature/onboarding/state/name_and_cal_state.dart';
import 'package:avo_ai_diet/product/cache/model/response/ai_response.dart';
import 'package:avo_ai_diet/product/constants/enum/custom/hero_lottie_enum.dart';
import 'package:avo_ai_diet/product/constants/enum/general/json_name.dart';
import 'package:avo_ai_diet/product/constants/enum/project_settings/app_padding.dart';
import 'package:avo_ai_diet/product/constants/enum/project_settings/app_radius.dart';
import 'package:avo_ai_diet/product/constants/project_colors.dart';
import 'package:avo_ai_diet/product/constants/project_strings.dart';
import 'package:avo_ai_diet/product/utility/extensions/json_extension.dart';
import 'package:avo_ai_diet/product/utility/extensions/text_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

final class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NameAndCalCubit, NameAndCalState>(
      builder: (context, nameCalState) {
        final targetCalories = nameCalState.targetCal ?? 2500;
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  nameCalState.name != null ? '${ProjectStrings.hello} ${nameCalState.name}' : ProjectStrings.hello,
                ),
                Hero(
                  tag: HeroLottie.avoLottie.value,
                  child: Lottie.asset(
                    fit: BoxFit.cover,
                    height: 70.h,
                    JsonName.avoWalk.path,
                  ),
                ),
              ],
            ),
          ),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(ProjectStrings.myDietList, style: context.textTheme().bodyLarge),
                          InkWell(
                            onTap: () {},
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add,
                                  size: 18.sp,
                                  color: ProjectColors.earthBrown,
                                ),
                                Text('Ekle', style: context.textTheme().bodySmall),
                              ],
                            ),
                          ),
                        ],
                      ),
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

class _ModernDietCard extends HookWidget {
  const _ModernDietCard();

  @override
  Widget build(BuildContext context) {
    final showShadow = useState(false);
    return Stack(
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            showShadow.value = scrollNotification.metrics.pixels > 10;
            return true;
          },
          child: SingleChildScrollView(
            child: BlocSelector<AiDietAdviceCubit, AiDietAdviceState,
                ({AiResponse? response, bool isLoading, String? error})>(
              selector: (state) => (response: state.response, isLoading: state.isLoading, error: state.error),
              builder: (context, data) {
                if (data.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (data.response == null) {
                  return Padding(
                    padding: AppPadding.mediumAll(),
                    child: Text(
                      data.error ?? 'Diyet planı yüklenemedi.',
                      style: context.textTheme().bodyMedium?.copyWith(color: ProjectColors.accentCoral),
                    ),
                  );
                }

                final response = data.response!;

                return Container(
                  margin: AppPadding.customSymmetricMediumSmall(),
                  decoration: BoxDecoration(
                    color: ProjectColors.white.withOpacity(0.6),
                    borderRadius: AppRadius.circularSmall(),
                    border: Border.all(color: ProjectColors.secondary.withOpacity(0.5)),
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
                                color: ProjectColors.primary.withOpacity(0.1),
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
                                    style: context.textTheme().titleMedium?.copyWith(color: ProjectColors.primary),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        response.formattedDayMonthYear,
                                        style: context.textTheme().bodySmall?.copyWith(
                                              fontSize: 13.sp,
                                              color: ProjectColors.grey,
                                            ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          // silme işlemi
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.delete_outline,
                                              size: 18.sp,
                                              color: ProjectColors.accentCoral,
                                            ),
                                            Text(
                                              'Sil',
                                              style: context.textTheme().bodySmall?.copyWith(
                                                    color: ProjectColors.accentCoral,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
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
                            p: context.textTheme().bodySmall?.copyWith(fontSize: 16.sp),
                            strong: context.textTheme().bodySmall?.copyWith(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                            em: context.textTheme().bodySmall?.copyWith(
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
              },
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: AnimatedOpacity(
            opacity: showShadow.value ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              height: 20,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    ProjectColors.black.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// TODOsearch için buton değiştir,textfield next koy
class _CalorieFollowIndicator extends StatelessWidget {
  const _CalorieFollowIndicator({required this.maxCalories});

  final double maxCalories;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DailyCalorieCubit, DailyCalorieState>(
      builder: (context, state) {
        final currentCalories = state.currentCalories;

        // Remaining calorie calculation and min 0 control
        final caloriesLeft = (maxCalories - currentCalories).clamp(0.0, maxCalories);

        double calculatePercent() {
          // If target calories and current calories are the same or current
          // calories are more
          if (currentCalories >= maxCalories) {
            return 1; // %100
          }
          return currentCalories / maxCalories;
        }

        final percent = calculatePercent();

        final percentDisplay = (percent * 100).round();

        // Adjust color by percentage
        Color getColorByPercent(double percent) {
          if (percent < 0.3) {
            return ProjectColors.green;
          } else if (percent < 0.7) {
            return ProjectColors.forestGreen;
          } else if (percent < 0.95) {
            return ProjectColors.sandyBrown;
          } else {
            return ProjectColors.accentCoral;
          }
        }

        final indicatorColor = getColorByPercent(percent);

        return Padding(
          padding: EdgeInsets.only(top: 16.h, bottom: 6.h),
          child: Row(
            children: [
              // Calorie CircularPercentIndicator
              Expanded(
                flex: 5,
                child: CircularPercentIndicator(
                  radius: 75.r,
                  lineWidth: 15,
                  animation: true,
                  animateFromLastPercent: true, // TODOanimation false?
                  percent: percent,
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$currentCalories',
                        style: context.textTheme().displayMedium?.copyWith(
                              fontSize: 32.sp,
                              fontWeight: FontWeight.bold,
                              color: currentCalories > 0 ? indicatorColor : ProjectColors.grey600,
                            ),
                      ),
                      Text(
                        'kalori',
                        style: context.textTheme().bodySmall?.copyWith(
                              color: ProjectColors.grey600,
                            ),
                      ),
                    ],
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  backgroundColor: ProjectColors.grey200,
                  progressColor: indicatorColor,
                ),
              ),

              // information to the right of the calorie indicator
              Expanded(
                flex: 5,
                child: Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Remaining calorie information
                      Row(
                        children: [
                          Icon(
                            Icons.local_fire_department,
                            color: ProjectColors.accentCoral,
                            size: 22.r,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            '${caloriesLeft.toInt()} kalori kaldı',
                            style: context.textTheme().bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),

                      SizedBox(height: 12.h),

                      // target calorie
                      Row(
                        children: [
                          Icon(
                            Icons.flag_outlined,
                            color: ProjectColors.green,
                            size: 22.r,
                          ),
                          SizedBox(width: 6.w),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Hedef: ',
                                  style: context.textTheme().bodyMedium?.copyWith(
                                        color: ProjectColors.grey600,
                                      ),
                                ),
                                TextSpan(
                                  text: '${maxCalories.toInt()} kcal',
                                  style: context.textTheme().bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 12.h),

                      // Consumption percentage
                      Row(
                        children: [
                          Icon(
                            Icons.pie_chart_outline_rounded,
                            color: indicatorColor,
                            size: 22.r,
                          ),
                          SizedBox(width: 6.w),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Tüketilen: ',
                                  style: context.textTheme().bodyMedium?.copyWith(
                                        color: ProjectColors.grey600,
                                      ),
                                ),
                                TextSpan(
                                  text: '%$percentDisplay',
                                  style: context.textTheme().bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: indicatorColor,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // calorie change buttons
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          _MiniAdjustButton(
                            text: '-100',
                            textColor: ProjectColors.green,
                            onPressed: () {
                              final newCalories = (currentCalories - 100).clamp(0, maxCalories.toInt());
                              context.read<DailyCalorieCubit>().setCalories(
                                    newCalories,
                                    maxCalories.toInt(),
                                  );
                            },
                          ),
                          SizedBox(width: 4.w),
                          _MiniAdjustButton(
                            text: '-10',
                            textColor: ProjectColors.green,
                            onPressed: () {
                              final newCalories = (currentCalories - 10).clamp(0, maxCalories.toInt());
                              context.read<DailyCalorieCubit>().setCalories(
                                    newCalories,
                                    maxCalories.toInt(),
                                  );
                            },
                          ),
                          SizedBox(width: 4.w),
                          _MiniAdjustButton(
                            text: '+10',
                            textColor: ProjectColors.accentCoral,
                            onPressed: () {
                              final newCalories = (currentCalories + 10).clamp(0, maxCalories.toInt());
                              context.read<DailyCalorieCubit>().setCalories(
                                    newCalories,
                                    maxCalories.toInt(),
                                  );
                            },
                          ),
                          SizedBox(width: 4.w),
                          _MiniAdjustButton(
                            text: '+100',
                            textColor: ProjectColors.accentCoral,
                            onPressed: () {
                              final newCalories = (currentCalories + 100).clamp(0, maxCalories.toInt());
                              context.read<DailyCalorieCubit>().setCalories(
                                    newCalories,
                                    maxCalories.toInt(),
                                  );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

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
            color: textColor.withOpacity(0.1),
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
