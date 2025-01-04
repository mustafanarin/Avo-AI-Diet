import 'package:avo_ai_diet/product/constants/enum/project_settings/app_padding.dart';
import 'package:avo_ai_diet/product/constants/enum/project_settings/app_radius.dart';
import 'package:avo_ai_diet/product/constants/project_colors.dart';
import 'package:avo_ai_diet/product/constants/project_strings.dart';
import 'package:avo_ai_diet/product/extensions/activity_level_extension.dart';
import 'package:avo_ai_diet/product/extensions/text_theme_extension.dart';
import 'package:avo_ai_diet/product/utility/calori_validators.dart';
import 'package:avo_ai_diet/product/widgets/project_button.dart';
import 'package:avo_ai_diet/product/widgets/project_textfield.dart';
import 'package:avo_ai_diet/services/calori_calculator_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final class UserInfoView extends HookWidget {
  UserInfoView({super.key});

  final _validators = CalorieValidators();

  final List<String> activityLevels = [
    'Sedanter (hareketsiz yaşam)',
    'Hafif aktif (haftada 1-3 gün egzersiz)',
    'Orta aktif (haftada 3-5 gün egzersiz)',
    'Çok aktif (haftada 6-7 gün egzersiz)',
    'Profesyonel sporcu seviyesi',
  ];

  final List<String> goals = [
    'Kilo vermek',
    'Kilo korumak',
    'Kilo almak',
  ];

  final List<String> budgets = [
    'Düşük bütçe',
    'Orta bütçe',
    'Yüksek bütçe',
  ];

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final currentStep = useState(0);

    // Form state hooks
    final gender = useState<String?>(null);
    final activityLevel = useState<String?>(null);
    final goal = useState<String?>(null);
    final budget = useState<String?>(null);
    final forceUpdate = useState(false);

    // TextEditing controllers
    final ageController = useTextEditingController();
    final heightController = useTextEditingController();
    final weightController = useTextEditingController();

    // Add listeners to trigger rebuild when text changes
    useEffect(
      () {
        void listener() => forceUpdate.value = !forceUpdate.value;

        ageController.addListener(listener);
        heightController.addListener(listener);
        weightController.addListener(listener);

        return () {
          ageController.removeListener(listener);
          heightController.removeListener(listener);
          weightController.removeListener(listener);
        };
      },
      [],
    );

    // Form validation
    bool validateCurrentStep() {
      switch (currentStep.value) {
        case 0:
          return gender.value != null &&
              _validators.validateAge(ageController.text) == null &&
              _validators.validateHeight(heightController.text) == null &&
              _validators.validateWeight(weightController.text) == null;
        case 1:
          return activityLevel.value != null;
        case 2:
          return goal.value != null;
        case 3:
          return budget.value != null;
        default:
          return false;
      }
    }

    StepState getStepState(int step) {
      if (currentStep.value > step) {
        return StepState.complete;
      }
      if (currentStep.value == step) {
        return StepState.editing;
      }
      return StepState.disabled;
    }

    void calculateCalories() {
      final weight = double.parse(weightController.text);
      final height = double.parse(heightController.text);
      final age = double.parse(ageController.text);

      final bmr = CalorieCalculatorService.calculateBMR(
        gender: gender.value!,
        weight: weight,
        height: height,
        age: age,
      );

      final selectedActivity = ActivityLevelExtension.fromDisplayName(activityLevel.value!);

      final totalCalories = CalorieCalculatorService.calculateTotalCalories(
        bmr: bmr,
        activityLevel: selectedActivity,
        goal: goal.value!,
      );

      // ignore: inference_failure_on_function_invocation
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: ProjectColors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20.r),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 20.h),
                decoration: BoxDecoration(
                  color: ProjectColors.grey200,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              Text(
                'Günlük Kalori İhtiyacınız',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: ProjectColors.forestGreen,
                ),
              ),
              SizedBox(height: 20.h),
              _ResultRow(
                label: 'Bazal Metabolizma Hızı (BMR):',
                value: '${bmr.round()} kcal',
              ),
              SizedBox(height: 12.h),
              _ResultRow(
                label: 'Günlük Kalori İhtiyacı:',
                value: '${totalCalories.round()} kcal',
              ),
              SizedBox(height: 12.h),
              _ResultRow(
                label: 'Seçilen Bütçe:',
                value: budget.value ?? '',
              ),
              SizedBox(height: 20.h),
              ProjectButton(
                text: 'TAMAM',
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: const _CustomAppbar(),
      body: Form(
        key: formKey,
        child: Stepper(
          currentStep: currentStep.value,
          elevation: 0,
          onStepTapped: (step) {
            if (step < currentStep.value) {
              currentStep.value = step;
            }
          },
          controlsBuilder: (context, details) {
            final isCurrentStepValid = validateCurrentStep();

            return _StepControls(
              currentStep: currentStep,
              isCurrentStepValid: isCurrentStepValid,
              calculateCalori: calculateCalories,
            );
          },
          steps: [
            Step(
              state: getStepState(0),
              title: Text(
                ProjectStrings.personelInfoTitle,
                style: context.textTheme().titleMedium,
              ),
              content: _PersonelInfoStep(
                gender: gender,
                ageController: ageController,
                validators: _validators,
                heightController: heightController,
                weightController: weightController,
              ),
              isActive: currentStep.value >= 0,
            ),
            Step(
              state: getStepState(1),
              title: Text(
                ProjectStrings.activityLevel,
                style: context.textTheme().titleMedium,
              ),
              content: _ActivityLevelStep(activityLevels: activityLevels, activityLevel: activityLevel),
              isActive: currentStep.value >= 1,
            ),
            Step(
              state: getStepState(2),
              title: Text(
                ProjectStrings.target,
                style: context.textTheme().titleMedium,
              ),
              content: _CaloriTargetStep(goals: goals, goal: goal),
              isActive: currentStep.value >= 2,
            ),
            Step(
              state: getStepState(3),
              title: Text(
                ProjectStrings.budget,
                style: context.textTheme().titleMedium,
              ),
              content: _BudgetStep(budgets: budgets, budget: budget),
              isActive: currentStep.value >= 3,
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const _CustomAppbar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        ProjectStrings.userInfoAppbar,
      ),
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      leading: const BackButton(
        color: ProjectColors.earthBrown,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _StepControls extends StatelessWidget {
  const _StepControls({
    required this.currentStep,
    required this.isCurrentStepValid,
    required this.calculateCalori,
  });

  final ValueNotifier<int> currentStep;
  final bool isCurrentStepValid;
  final void Function() calculateCalori;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.onlyTopXmedium(),
      child: Column(
        children: [
          ProjectButton(
            text: currentStep.value == 3 ? ProjectStrings.calculatButton : ProjectStrings.continueButton,
            onPressed: isCurrentStepValid
                ? () {
                    if (currentStep.value < 3) {
                      currentStep.value += 1;
                    } else {
                      calculateCalori();
                    }
                  }
                : null,
            isEnabled: isCurrentStepValid,
          ),
          if (currentStep.value > 0) ...[
            SizedBox(height: 12.h),
            BackButton(
              onPressed: () {
                currentStep.value -= 1;
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _PersonelInfoStep extends StatelessWidget {
  const _PersonelInfoStep({
    required this.gender,
    required this.ageController,
    required CalorieValidators validators,
    required this.heightController,
    required this.weightController,
  }) : _validators = validators;

  final ValueNotifier<String?> gender;
  final TextEditingController ageController;
  final CalorieValidators _validators;
  final TextEditingController heightController;
  final TextEditingController weightController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: ProjectColors.white,
            borderRadius: AppRadius.circularSmall(),
            border: Border.all(color: ProjectColors.grey200),
          ),
          child: Column(
            children: [
              RadioListTile<String>(
                title: const Text(ProjectStrings.male),
                value: ProjectStrings.male,
                groupValue: gender.value,
                activeColor: ProjectColors.forestGreen,
                onChanged: (value) => gender.value = value,
              ),
              const Divider(height: 1),
              RadioListTile<String>(
                title: const Text(ProjectStrings.female),
                value: ProjectStrings.female,
                groupValue: gender.value,
                activeColor: ProjectColors.forestGreen,
                onChanged: (value) => gender.value = value,
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        ProjectTextField(
          controller: ageController,
          labelText: ProjectStrings.age,
          validator: _validators.validateAge,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 16.h),
        ProjectTextField(
          controller: heightController,
          labelText: ProjectStrings.size,
          validator: _validators.validateHeight,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 16.h),
        ProjectTextField(
          controller: weightController,
          labelText: ProjectStrings.weight,
          validator: _validators.validateWeight,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}

class _ActivityLevelStep extends StatelessWidget {
  const _ActivityLevelStep({
    required this.activityLevels,
    required this.activityLevel,
  });

  final List<String> activityLevels;
  final ValueNotifier<String?> activityLevel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ProjectColors.white,
        borderRadius: AppRadius.circularSmall(),
        border: Border.all(color: ProjectColors.grey200),
      ),
      child: Column(
        children: activityLevels.map((level) {
          return Column(
            children: [
              RadioListTile<String>(
                title: Text(level, style: context.textTheme().bodyLarge?.copyWith(color: ProjectColors.black)),
                value: level,
                groupValue: activityLevel.value,
                activeColor: ProjectColors.forestGreen,
                onChanged: (value) => activityLevel.value = value,
              ),
              if (level != activityLevels.last) const Divider(height: 1),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _CaloriTargetStep extends StatelessWidget {
  const _CaloriTargetStep({
    required this.goals,
    required this.goal,
  });

  final List<String> goals;
  final ValueNotifier<String?> goal;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ProjectColors.white,
        borderRadius: AppRadius.circularSmall(),
        border: Border.all(color: ProjectColors.grey200),
      ),
      child: Column(
        children: goals.map((g) {
          return Column(
            children: [
              RadioListTile<String>(
                title: Text(g, style: context.textTheme().bodyLarge?.copyWith(color: ProjectColors.black)),
                value: g,
                groupValue: goal.value,
                activeColor: ProjectColors.forestGreen,
                onChanged: (value) => goal.value = value,
              ),
              if (g != goals.last) const Divider(height: 1),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _BudgetStep extends StatelessWidget {
  const _BudgetStep({
    required this.budgets,
    required this.budget,
  });

  final List<String> budgets;
  final ValueNotifier<String?> budget;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ProjectColors.white,
        borderRadius: AppRadius.circularSmall(),
        border: Border.all(color: ProjectColors.grey200),
      ),
      child: Column(
        children: budgets.map((b) {
          return Column(
            children: [
              RadioListTile<String>(
                title: Text(
                  b,
                  style: context.textTheme().bodyLarge?.copyWith(color: ProjectColors.black),
                ),
                value: b,
                groupValue: budget.value,
                activeColor: ProjectColors.forestGreen,
                onChanged: (value) => budget.value = value,
              ),
              if (b != budgets.last) const Divider(height: 1),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16.sp),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: ProjectColors.black,
          ),
        ),
      ],
    );
  }
}
