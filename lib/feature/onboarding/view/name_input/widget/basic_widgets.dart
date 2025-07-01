part of '../name_input_view.dart';

class _AvoMascotLottie extends StatelessWidget {
  const _AvoMascotLottie();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        JsonName.avoAnimation.path,
        height: 280.h,
      ),
    );
  }
}

class _TitleText extends StatelessWidget {
  const _TitleText();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        ProjectStrings.nameInputTitle,
        style: context.textTheme().displayLarge,
      ),
    );
  }
}

class _DescriptionText extends StatelessWidget {
  const _DescriptionText();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        ProjectStrings.nameInputDescription,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _ContinueButton extends StatelessWidget {
  const _ContinueButton({
    required this.isButtonEnabled,
    required this.nameController,
  });

  final TextEditingController nameController;
  final ValueNotifier<bool> isButtonEnabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.smallHorizontal(),
      child: ProjectButton(
        text: ProjectStrings.nameInputButton,
        onPressed: () {
          context.push(
            RouteNames.userInfoPath(nameController.text),
          );
        },
        isEnabled: isButtonEnabled.value,
      ),
    );
  }
}
