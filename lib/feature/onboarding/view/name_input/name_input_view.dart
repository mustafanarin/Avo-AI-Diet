import 'package:avo_ai_diet/product/constants/enum/general/json_name.dart';
import 'package:avo_ai_diet/product/constants/enum/project_settings/app_padding.dart';
import 'package:avo_ai_diet/product/constants/project_strings.dart';
import 'package:avo_ai_diet/product/constants/route_names.dart';
import 'package:avo_ai_diet/product/utility/extensions/json_extension.dart';
import 'package:avo_ai_diet/product/utility/extensions/text_theme_extension.dart';
import 'package:avo_ai_diet/product/widgets/project_button.dart';
import 'package:avo_ai_diet/product/widgets/project_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

part './widget/basic_widgets.dart';

final class NameInputView extends HookWidget {
  const NameInputView({super.key});

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

    return GestureDetector(
      onTap: focusNode.unfocus,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Padding(
              padding: AppPadding.largeAll(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _AvoMascotLottie(),
                  SizedBox(height: 32.h),
                  const _TitleText(),
                  SizedBox(height: 16.h),
                  const _DescriptionText(),
                  SizedBox(height: 40.h),
                  ProjectTextField(
                    controller: nameController,
                    focusNode: focusNode,
                    hintText: ProjectStrings.nameInputHintText,
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
    );
  }
}
