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

    return Scaffold(
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
    );
  }
}
// TODO klavye dışına basılınca kapat
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
