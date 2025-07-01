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

part './widgets/basic_widgets.dart';

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
