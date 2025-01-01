import 'package:avo_ai_diet/product/constants/enum/project_settings/app_padding.dart';
import 'package:avo_ai_diet/product/constants/project_colors.dart';
import 'package:avo_ai_diet/product/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class HomeView extends StatefulWidget {
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
            Text('Merhaba ${widget.userName}'),
            // Image.asset(
            //   height: 60,
            //   'assets/png/justAvo.png'),
            Lottie.asset(
              fit: BoxFit.cover,
              height: 70,
              'assets/json/avoWalk.json',
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: AppPadding.mediumHorizontal(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CalorieCounterPage(maxCalories: widget.targetCal),
              SizedBox(height: 30.h),
              Text('Diyet Listelerim', style: context.textTheme().bodyLarge),
            ],
          ),
        ),
      ),
    );
  }
}

class _CalorieCounterPage extends HookWidget {
  const _CalorieCounterPage({required this.maxCalories});

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
