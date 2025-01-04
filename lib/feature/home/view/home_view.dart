import 'package:avo_ai_diet/product/constants/enum/general/json_name.dart';
import 'package:avo_ai_diet/product/constants/enum/project_settings/app_padding.dart';
import 'package:avo_ai_diet/product/constants/enum/project_settings/app_radius.dart';
import 'package:avo_ai_diet/product/constants/project_colors.dart';
import 'package:avo_ai_diet/product/constants/project_strings.dart';
import 'package:avo_ai_diet/product/extensions/json_extension.dart';
import 'package:avo_ai_diet/product/extensions/text_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

final class HomeView extends StatefulWidget {
  const HomeView({required this.userName, required this.targetCal, super.key});
  final String userName;
  final double targetCal;
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${ProjectStrings.hello} ${widget.userName}'),
            Lottie.asset(
              fit: BoxFit.cover,
              height: 70.h,
              JsonName.avoWalk.path,
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
                  _CalorieFollowSlider(maxCalories: widget.targetCal),
                  SizedBox(height: 30.h),
                  Text(ProjectStrings.myDietList, style: context.textTheme().bodyLarge),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            const Expanded(
              child: ModernDietCard(
                date: '3 Ocak 2025',
                suggestion: 'Sucuklu yumurta',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ModernDietCard extends StatelessWidget {
  const ModernDietCard({
    required this.date,
    required this.suggestion,
    super.key,
  });
  final String date;
  final String suggestion;

  @override
  Widget build(BuildContext context) {
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
                      Text(
                        date,
                        style: context.textTheme().bodySmall?.copyWith(
                              fontSize: 13,
                              color: ProjectColors.grey,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: AppPadding.mediumAll(),
            child: Text(
              suggestion,
              style: context.textTheme().bodySmall?.copyWith(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalorieFollowSlider extends HookWidget {
  const _CalorieFollowSlider({required this.maxCalories});

  final double maxCalories;

  @override
  Widget build(BuildContext context) {
    final currentCalories = useState(0);

    final caloriesLeft = maxCalories - currentCalories.value;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_fire_department,
            color: ProjectColors.accentCoral,
            size: 50.r,
          ),
          Text(
            currentCalories.value.toStringAsFixed(0),
            style: context.textTheme().displayLarge?.copyWith(
                  fontSize: 40,
                ),
          ),
          Text(
            '${caloriesLeft.toStringAsFixed(0)} kalori kaldı.',
            style: context.textTheme().bodyMedium,
          ),
          SizedBox(height: 20.h),
          SliderTheme(
            data: _customSliderTheme(currentCalories),
            child: Slider(
              value: currentCalories.value.toDouble(),
              max: maxCalories,
              divisions: (maxCalories / 10).round(),
              onChanged: (value) {
                currentCalories.value = value.toInt();
              },
            ),
          ),
        ],
      ),
    );
  }

  SliderThemeData _customSliderTheme(ValueNotifier<int> currentCalories) {
    return SliderThemeData(
      trackHeight: 20,
      thumbShape: const RoundSliderThumbShape(
        pressedElevation: 5,
        enabledThumbRadius: 15,
        elevation: 2,
      ),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),

      // The color gets darker as the calories consumed increase
      activeTrackColor: HSLColor.fromColor(ProjectColors.forestGreen)
          .withLightness(1 - (currentCalories.value * 0.75 / maxCalories))
          .toColor(),
      inactiveTrackColor: ProjectColors.grey400,

      // Green color until about half of maximum calories and then activeTrackColor
      thumbColor: currentCalories.value <= maxCalories * 2 / 3
          ? ProjectColors.green
          : HSLColor.fromColor(ProjectColors.forestGreen)
              .withLightness(1 - (currentCalories.value * 0.75 / maxCalories))
              .toColor(),
    );
  }
}
