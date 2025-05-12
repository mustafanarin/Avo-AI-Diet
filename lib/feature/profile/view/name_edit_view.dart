import 'package:avo_ai_diet/feature/onboarding/cubit/name_and_cal_cubit.dart';
import 'package:avo_ai_diet/feature/profile/cubit/name_edit_cubit.dart';
import 'package:avo_ai_diet/feature/profile/state/name_edit_state.dart';
import 'package:avo_ai_diet/product/constants/enum/general/json_name.dart';
import 'package:avo_ai_diet/product/constants/enum/project_settings/app_padding.dart';
import 'package:avo_ai_diet/product/constants/project_colors.dart';
import 'package:avo_ai_diet/product/constants/project_strings.dart';
import 'package:avo_ai_diet/product/utility/extensions/json_extension.dart';
import 'package:avo_ai_diet/product/utility/extensions/text_theme_extension.dart';
import 'package:avo_ai_diet/product/utility/init/service_locator.dart';
import 'package:avo_ai_diet/product/widgets/project_button.dart';
import 'package:avo_ai_diet/product/widgets/project_textfield.dart';
import 'package:avo_ai_diet/product/widgets/project_toast_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

final class NameEditView extends HookWidget {
  const NameEditView({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = useTextEditingController();
    final isButtonEnabled = useState(false);
    final focusNode = useFocusNode();

    useEffect(
      () {
        void listener() {
          isButtonEnabled.value = nameController.text.trim().isNotEmpty;
        }

        nameController.addListener(listener);
        return () => nameController.removeListener(listener);
      },
      [nameController],
    );

    return BlocProvider(
      create: (context) => getIt<NameEditCubit>(),
      child: GestureDetector(
        onTap: focusNode.unfocus,
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: AppPadding.customSymmetricMediumSmall(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        context.pop();
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const _AvoMascotLottie(),
                    SizedBox(height: 32.h),
                    const _TitleText(),
                    SizedBox(height: 16.h),
                    const _DescriptionText(),
                    SizedBox(height: 40.h),
                    ProjectTextField(
                      controller: nameController,
                      focusNode: focusNode,
                      hintText: ProjectStrings.inputNewName,
                    ),
                    SizedBox(height: 32.h),
                    _ContinueButton(
                      isButtonEnabled: isButtonEnabled,
                      nameController: nameController,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

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
