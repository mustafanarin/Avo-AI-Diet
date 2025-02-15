import 'package:avo_ai_diet/feature/onboarding/cubit/name_and_cal_cubit.dart';
import 'package:avo_ai_diet/feature/onboarding/state/name_and_cal_state.dart';
import 'package:avo_ai_diet/product/cache/reponse_manager/ai_response_manager.dart';
import 'package:avo_ai_diet/product/constants/enum/general/json_name.dart';
import 'package:avo_ai_diet/product/constants/enum/project_settings/app_padding.dart';
import 'package:avo_ai_diet/product/constants/enum/project_settings/app_radius.dart';
import 'package:avo_ai_diet/product/constants/project_colors.dart';
import 'package:avo_ai_diet/product/constants/project_strings.dart';
import 'package:avo_ai_diet/product/extensions/json_extension.dart';
import 'package:avo_ai_diet/product/extensions/text_theme_extension.dart';
import 'package:avo_ai_diet/product/model/response/ai_response.dart';
import 'package:avo_ai_diet/product/utility/init/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

final class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  AiResponse? _response;
  late final AiResponseManager _manager;

  @override
  void initState() {
    super.initState();
    _manager = getIt<AiResponseManager>();
    _loadDietPlan();
  }

  Future<void> _loadDietPlan() async {
    final result = await _manager.getDietPlan();
    setState(() {
      _response = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NameAndCalCubit, NameAndCalState>(
      builder: (context, nameCalState) {
        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  nameCalState.name != null ? '${ProjectStrings.hello} ${nameCalState.name}' : ProjectStrings.hello,
                ),
                Hero(
                  // TODOhero animation
                  tag: 'avoLottie',
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
                      _CalorieFollowSlider(maxCalories: nameCalState.targetCal ?? 2500),
                      SizedBox(height: 30.h),
                      Text(ProjectStrings.myDietList, style: context.textTheme().bodyLarge),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                Expanded(
                  child: ModernDietCard(
                    response: _response,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ModernDietCard extends StatelessWidget {
  const ModernDietCard({required this.response, super.key});

  final AiResponse? response;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
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
                          '${response?.formattedDayMonthYear}',
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
              child: response == null
                  ? const CircularProgressIndicator()
                  : Text(
                      response!.dietPlan,
                      style: context.textTheme().bodySmall?.copyWith(fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CalorieFollowSlider extends HookWidget {
  const _CalorieFollowSlider({required this.maxCalories});

  final double maxCalories;

  int _calculateDivisions() {
    // Calculates the number of divisions for a slider based on maxCalories, ensuring a minimum of 100 if the result is non-positive.
    final calculatedDivisions = (maxCalories / 10).round();
    return calculatedDivisions > 0 ? calculatedDivisions : 100;
  }

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
              divisions: _calculateDivisions(),
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
    // Keep the Lightness value between 0.0 - 1.0
    double calculateLightness() {
      final ratio = currentCalories.value / maxCalories;
      // 0.2 minimum lightness, 0.8 maximum lightness
      return 0.8 - (ratio * 0.6).clamp(0.0, 0.6);
    }

    final lightness = calculateLightness();

    return SliderThemeData(
      trackHeight: 20,
      thumbShape: const RoundSliderThumbShape(
        pressedElevation: 5,
        enabledThumbRadius: 15,
        elevation: 2,
      ),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),

      // The color gets darker as the calories consumed increase
      activeTrackColor: HSLColor.fromColor(ProjectColors.forestGreen).withLightness(lightness).toColor(),
      inactiveTrackColor: ProjectColors.grey400,

      // Green color until about half of maximum calories and then activeTrackColor
      thumbColor: currentCalories.value <= maxCalories * 2 / 3
          ? ProjectColors.green
          : HSLColor.fromColor(ProjectColors.forestGreen).withLightness(lightness).toColor(),
    );
  }
}
