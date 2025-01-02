import 'package:avo_ai_diet/product/constants/enum/project_settings/app_padding.dart';
import 'package:avo_ai_diet/product/constants/project_colors.dart';
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
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
            SizedBox(
              height: 8.h,
            ),
            Expanded(
              child: CardCarousel(
                items: [
                  DietCardItem(
                    title: 'Günlük Beslenme Planı',
                    aiResponse: 'Sucuklu yumurta',
                    date: '2 Ocak 2025',
                  ),
                  DietCardItem(
                    title: 'Günlük Beslenme Planı',
                    aiResponse: 'Sucuklu yumurta',
                    date: '2 Ocak 2025',
                  ),
                  DietCardItem(
                    title: 'Günlük Beslenme Planı',
                    aiResponse: 'Sucuklu yumurta',
                    date: '2 Ocak 2025',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardCarousel extends StatelessWidget {
  const CardCarousel({
    required this.items,
    super.key,
  });
  final List<DietCardItem> items;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: PageView.builder(
        controller: PageController(
          viewportFraction: 0.9,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      items[index].title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: ProjectColors.darkAvocado,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      items[index].date,
                      style: const TextStyle(
                        fontSize: 14,
                        color: ProjectColors.grey600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Text(
                          items[index].aiResponse,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class DietCardItem {
  DietCardItem({
    required this.title,
    required this.aiResponse,
    required this.date,
  });
  final String title;
  final String aiResponse;
  final String date;
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
