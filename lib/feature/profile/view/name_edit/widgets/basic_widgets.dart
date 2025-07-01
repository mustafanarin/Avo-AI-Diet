part of '../name_edit_view.dart';
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
        ProjectStrings.updateName,
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
        ProjectStrings.updateNameDesc,
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
      child: BlocBuilder<NameEditCubit, NameEditState>(
        builder: (context, state) {
          return ProjectButton(
            text: state.isLoading ? ProjectStrings.saving : ProjectStrings.save,
            onPressed: isButtonEnabled.value ? () => _handleButtonPress(context, state) : null,
            isEnabled: isButtonEnabled.value,
          );
        },
      ),
    );
  }

  Future<void> _handleButtonPress(BuildContext context, NameEditState state) async {
    final nameEditCubit = context.read<NameEditCubit>();
    final nameAndCalCubit = context.read<NameAndCalCubit>();

    await nameEditCubit.updateName(nameController.text.trim());

    if (!context.mounted) return;

    final currentState = nameEditCubit.state;

    if (currentState.error == null) {
      await _handleSuccess(context, nameAndCalCubit);
    } else {
      _showErrorMessage(context, currentState.error!);
    }
  }

  Future<void> _handleSuccess(BuildContext context, NameAndCalCubit nameAndCalCubit) async {
    ProjectToastMessage.show(
      context,
      ProjectStrings.nameSuccessful,
      isThereIcon: false,
    );

    if (context.mounted) {
      await nameAndCalCubit.refreshData();

      if (context.mounted) {
        context.pop();
      }
    }
  }

  void _showErrorMessage(BuildContext context, String error) {
    ProjectToastMessage.show(
      context,
      error,
      isThereIcon: false,
      backGroundColor: ProjectColors.earthBrown,
    );
  }
}
