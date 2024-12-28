import 'package:avo_ai_diet/feature/onboarding/view/name_input_view.dart';
import 'package:avo_ai_diet/product/constants/enum/project_settings/app_durations.dart';
import 'package:avo_ai_diet/product/constants/enum/project_settings/app_radius.dart';
import 'package:avo_ai_diet/product/constants/enum/general/png_name.dart';
import 'package:avo_ai_diet/product/constants/project_colors.dart';
import 'package:avo_ai_diet/product/constants/project_strings.dart';
import 'package:avo_ai_diet/product/extensions/context_extension.dart';
import 'package:avo_ai_diet/product/extensions/png_extension.dart';
import 'package:avo_ai_diet/product/widgets/project_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomeView extends HookWidget {
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
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            _AnimationAvoMascotImage(opacity: opacity),
            const Spacer(flex: 2),
            _animationContainer(),
          ],
        ),
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
          color: ProjectColors.black.withOpacity(0.1),
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
      child: Image.asset(
        PngName.avo.path,
        height: 0.5.sh,
        width: 1.sw,
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
    return ProjectButton(
      text: ProjectStrings.welcomeButton,
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const NameInputPage()));
      },
    );
  }
}
