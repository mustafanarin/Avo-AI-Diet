part of '../welcome_view.dart';

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
