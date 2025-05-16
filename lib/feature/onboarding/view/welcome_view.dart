import 'package:avo_ai_diet/product/constants/enum/general/png_name.dart';
import 'package:avo_ai_diet/product/constants/enum/project_settings/app_durations.dart';
import 'package:avo_ai_diet/product/constants/enum/project_settings/app_radius.dart';
import 'package:avo_ai_diet/product/constants/project_colors.dart';
import 'package:avo_ai_diet/product/constants/project_strings.dart';
import 'package:avo_ai_diet/product/constants/route_names.dart';
import 'package:avo_ai_diet/product/utility/extensions/png_extension.dart';
import 'package:avo_ai_diet/product/utility/extensions/text_theme_extension.dart';
import 'package:avo_ai_diet/product/widgets/project_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

final class WelcomeView extends HookWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final opacity = useState(0);
    useEffect(
      () {
        Future.delayed(AppDurations.smallMilliseconds(), () {
          opacity.value = 1;
        });
        return null;
      },
      [],
    );

    return Scaffold(
      body: Column(
        children: [
          const Spacer(
            flex: 3,
          ),
          _AnimationAvoMascotImage(opacity: opacity),
          const Spacer(flex: 2),
          _animationContainer(),
        ],
      ),
    );
  }

  TweenAnimationBuilder<double> _animationContainer() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 2, end: 0),
      duration: AppDurations.oneSeconds(),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 100 * value),
          child: child,
        );
      },
      child: Container(
        width: 1.sw,
        decoration: _specialBoxDecoration(),
        height: 0.35.sh,
        child: Padding(
          padding: EdgeInsets.all(25.r),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _WelcomeTitle(),
              _WelcomeDescription(),
              _LetsStartButton(),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _specialBoxDecoration() {
    return BoxDecoration(
      color: ProjectColors.white,
      borderRadius: AppRadius.topLargeRadius(),
      boxShadow: [
        BoxShadow(
          color: ProjectColors.black.withValues(alpha: 0.1),
          blurRadius: 10,
          offset: const Offset(0, -5),
        ),
      ],
    );
  }
}

class _AnimationAvoMascotImage extends StatelessWidget {
  const _AnimationAvoMascotImage({
    required this.opacity,
  });

  final ValueNotifier<int> opacity;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: AppDurations.oneSeconds(),
      opacity: opacity.value.toDouble(),
      curve: Curves.easeInOut,
      child: Column(
        children: [
          Image.asset(
            PngName.welcomeAvo.path,
            height: 250.h,
          ),
          Image.asset(
            PngName.appName.path,
            height: 100.h,
          ),
        ],
      ),
    );
  }
}

class _WelcomeTitle extends StatelessWidget {
  const _WelcomeTitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      ProjectStrings.welcomeTitle,
      style: context.textTheme().displayLarge,
    );
  }
}

class _WelcomeDescription extends StatelessWidget {
  const _WelcomeDescription();

  @override
  Widget build(BuildContext context) {
    return const Text(
      ProjectStrings.welcomeDescription,
      textAlign: TextAlign.center,
    );
  }
}

class _LetsStartButton extends StatelessWidget {
  const _LetsStartButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ProjectButton(
        text: ProjectStrings.welcomeButton,
        onPressed: () {
          context.go(RouteNames.nameInput);
        },
      ),
    );
  }
}
