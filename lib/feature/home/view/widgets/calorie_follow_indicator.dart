part of '../home_view.dart';


// Calorie Follow Indicator
class _CalorieFollowIndicator extends StatelessWidget {
  const _CalorieFollowIndicator({required this.maxCalories});

  final double maxCalories;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme();
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
                  animateFromLastPercent: true,
                  percent: percent,
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$currentCalories',
                        style: textTheme.displayMedium?.copyWith(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                          color: currentCalories > 0 ? indicatorColor : ProjectColors.grey600,
                        ),
                      ),
                      Text(
                        'kalori',
                        style: textTheme.bodySmall?.copyWith(
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
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: ProjectColors.grey600,
                                  ),
                                ),
                                TextSpan(
                                  text: '${maxCalories.toInt()} kcal',
                                  style: textTheme.bodyMedium?.copyWith(
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
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: ProjectColors.grey600,
                                  ),
                                ),
                                TextSpan(
                                  text: '%$percentDisplay',
                                  style: textTheme.bodyMedium?.copyWith(
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

