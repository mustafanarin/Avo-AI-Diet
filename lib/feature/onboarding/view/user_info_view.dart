import 'package:avo_ai_diet/feature/onboarding/cubit/name_and_cal_cubit.dart';
import 'package:avo_ai_diet/feature/onboarding/cubit/user_info_cubit.dart';
import 'package:avo_ai_diet/feature/onboarding/model/user_info_model.dart';
import 'package:avo_ai_diet/feature/onboarding/state/user_info_state.dart';
import 'package:avo_ai_diet/product/constants/enum/general/json_name.dart';
import 'package:avo_ai_diet/product/constants/enum/project_settings/app_padding.dart';
import 'package:avo_ai_diet/product/constants/enum/project_settings/app_radius.dart';
import 'package:avo_ai_diet/product/constants/project_colors.dart';
import 'package:avo_ai_diet/product/constants/project_strings.dart';
import 'package:avo_ai_diet/product/constants/route_names.dart';
import 'package:avo_ai_diet/product/extensions/activity_level_extension.dart';
import 'package:avo_ai_diet/product/extensions/json_extension.dart';
import 'package:avo_ai_diet/product/extensions/text_theme_extension.dart';
import 'package:avo_ai_diet/product/model/name_calori/name_and_cal.dart';
import 'package:avo_ai_diet/product/utility/calori_validators.dart';
import 'package:avo_ai_diet/product/utility/init/service_locator.dart';
import 'package:avo_ai_diet/product/widgets/project_button.dart';
import 'package:avo_ai_diet/product/widgets/project_textfield.dart';
import 'package:avo_ai_diet/services/calori_calculator_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class UserInfoView extends StatefulWidget {
  const UserInfoView({required this.userName, super.key});
  final String userName;
  @override
  State<UserInfoView> createState() => _UserInfoViewState();
}

class _UserInfoViewState extends State<UserInfoView> {
  final _formKey = GlobalKey<FormState>();
  final _validators = CalorieValidators();
  int _currentStep = 0;

  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  String? _gender;
  String? _activityLevel;
  String? _goal;
  String? _budget;

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
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  // Check validation of each step
  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _gender != null &&
            _validators.validateAge(_ageController.text) == null &&
            _validators.validateHeight(_heightController.text) == null &&
            _validators.validateWeight(_weightController.text) == null;
      case 1:
        return _activityLevel != null;
      case 2:
        return _goal != null;
      case 3:
        return _budget != null;
      default:
        return false;
    }
  }

  // Check the status of the stepper
  StepState _getStepState(int step) {
    if (_currentStep > step) return StepState.complete;
    if (_currentStep == step) return StepState.editing;
    return StepState.disabled;
  }

  Future<void> _submitForm(BuildContext context, UserInfoCubit cubit) async {
    if (!_validateCurrentStep()) return;

    final userInfo = UserInfoModel(
      height: double.parse(_heightController.text),
      weight: double.parse(_weightController.text),
      age: double.parse(_ageController.text),
      gender: _gender!,
      activityLevel: _activityLevel!,
      target: _goal!,
      budget: _budget!,
    );

    await cubit.submitUserInfo(userInfo);
  }

  void _navigateToHome(
    BuildContext context, {
    required String userName,
    required double targetCal,
  }) {
    if (!mounted) return;

    final cubit = context.read<NameAndCalCubit>();
    final nameAndCal = NameAndCalModel(userName: userName, targetCal: targetCal);

    cubit.submitNameAndCal(nameAndCal);

    const path = RouteNames.tabbar;
    context.go(path);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<UserInfoCubit>(),
      child: Builder(
        builder: (context) {
          return BlocConsumer<UserInfoCubit, UserInfoState>(
            listener: (context, state) {
              if (state.error != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error!)),
                );
              }
              if (state.isLoading) {}
              if (state.response != null) {
                final weight = double.parse(_weightController.text);
                final height = double.parse(_heightController.text);
                final age = double.parse(_ageController.text);

                final bmr = CalorieCalculatorService.calculateBMR(
                  gender: _gender!,
                  weight: weight,
                  height: height,
                  age: age,
                );

                final selectedActivity = ActivityLevelExtension.fromDisplayName(_activityLevel!);

                final totalCalories = CalorieCalculatorService.calculateTotalCalories(
                  bmr: bmr,
                  activityLevel: selectedActivity,
                  goal: _goal!,
                );

                _navigateToHome(
                  context,
                  userName: widget.userName,
                  targetCal: totalCalories,
                );
              }
            },
            builder: (context, state) {
              final cubit = context.read<UserInfoCubit>();
              return state.isLoading
                  ? Scaffold(
                      body: Center(
                        child: Column(
                          children: [
                            Hero(
                              tag: 'avoLottie',
                              child: Lottie.asset(JsonName.avoWalk.path),
                            ),
                            const Text('Senin için en uygun diyet planını hazırlıyorum :)'),
                          ],
                        ),
                      ),
                    )
                  : Scaffold(
                      appBar: const _CustomAppbar(),
                      body: Form(
                        key: _formKey,
                        child: Stepper(
                          currentStep: _currentStep,
                          elevation: 0,
                          onStepTapped: (step) {
                            if (step < _currentStep) {
                              setState(() => _currentStep = step);
                            }
                          },
                          controlsBuilder: (context, details) {
                            return Padding(
                              padding: AppPadding.onlyTopXmedium(),
                              child: Column(
                                children: [
                                  ProjectButton(
                                    text: _currentStep == 3
                                        ? ProjectStrings.calculatButton
                                        : ProjectStrings.continueButton,
                                    onPressed: !_validateCurrentStep() || state.isLoading
                                        ? null
                                        : () {
                                            if (_currentStep < 3) {
                                              setState(() => _currentStep += 1);
                                            } else {
                                              _submitForm(context, cubit);
                                            }
                                          },
                                    isEnabled: _validateCurrentStep() && !state.isLoading,
                                  ),
                                  if (_currentStep > 0) ...[
                                    SizedBox(height: 12.h),
                                    BackButton(
                                      onPressed: () {
                                        setState(() => _currentStep -= 1);
                                      },
                                    ),
                                  ],
                                ],
                              ),
                            );
                          },
                          steps: [
                            Step(
                              state: _getStepState(0),
                              title: Text(
                                ProjectStrings.personelInfoTitle,
                                style: context.textTheme().titleMedium,
                              ),
                              content: _PersonelInfoStep(
                                gender: _gender,
                                onGenderChanged: (value) => setState(() => _gender = value),
                                ageController: _ageController,
                                validators: _validators,
                                heightController: _heightController,
                                weightController: _weightController,
                              ),
                              isActive: _currentStep >= 0,
                            ),
                            Step(
                              state: _getStepState(1),
                              title: Text(
                                ProjectStrings.activityLevel,
                                style: context.textTheme().titleMedium,
                              ),
                              content: _ActivityLevelStep(
                                activityLevels: activityLevels,
                                activityLevel: _activityLevel,
                                onActivityLevelChanged: (value) => setState(() => _activityLevel = value),
                              ),
                              isActive: _currentStep >= 1,
                            ),
                            Step(
                              state: _getStepState(2),
                              title: Text(
                                ProjectStrings.target,
                                style: context.textTheme().titleMedium,
                              ),
                              content: _CaloriTargetStep(
                                goals: goals,
                                goal: _goal,
                                onGoalChanged: (value) => setState(() => _goal = value),
                              ),
                              isActive: _currentStep >= 2,
                            ),
                            Step(
                              state: _getStepState(3),
                              title: Text(
                                ProjectStrings.budget,
                                style: context.textTheme().titleMedium,
                              ),
                              content: _BudgetStep(
                                budgets: budgets,
                                budget: _budget,
                                onBudgetChanged: (value) => setState(() => _budget = value),
                              ),
                              isActive: _currentStep >= 3,
                            ),
                          ],
                        ),
                      ),
                    );
            },
          );
        },
      ),
    );
  }
}

class _PersonelInfoStep extends StatelessWidget {
  const _PersonelInfoStep({
    required this.gender,
    required this.onGenderChanged,
    required this.ageController,
    required this.validators,
    required this.heightController,
    required this.weightController,
  });

  final String? gender;
  final void Function(String?) onGenderChanged;
  final TextEditingController ageController;
  final CalorieValidators validators;
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
                groupValue: gender,
                activeColor: ProjectColors.forestGreen,
                onChanged: onGenderChanged,
              ),
              const Divider(height: 1),
              RadioListTile<String>(
                title: const Text(ProjectStrings.female),
                value: ProjectStrings.female,
                groupValue: gender,
                activeColor: ProjectColors.forestGreen,
                onChanged: onGenderChanged,
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        ProjectTextField(
          controller: ageController,
          labelText: ProjectStrings.age,
          validator: validators.validateAge,
          keyboardType: TextInputType.number,
          onChanged: (_) => onGenderChanged(gender), // To trigger validation
        ),
        SizedBox(height: 16.h),
        ProjectTextField(
          controller: heightController,
          labelText: ProjectStrings.size,
          validator: validators.validateHeight,
          keyboardType: TextInputType.number,
          onChanged: (_) => onGenderChanged(gender),
        ),
        SizedBox(height: 16.h),
        ProjectTextField(
          controller: weightController,
          labelText: ProjectStrings.weight,
          validator: validators.validateWeight,
          keyboardType: TextInputType.number,
          onChanged: (_) => onGenderChanged(gender),
        ),
      ],
    );
  }
}

class _ActivityLevelStep extends StatelessWidget {
  const _ActivityLevelStep({
    required this.activityLevels,
    required this.activityLevel,
    required this.onActivityLevelChanged,
  });

  final List<String> activityLevels;
  final String? activityLevel;
  final void Function(String?) onActivityLevelChanged;

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
                title: Text(
                  level,
                  style: context.textTheme().bodyLarge?.copyWith(
                        color: ProjectColors.black,
                      ),
                ),
                value: level,
                groupValue: activityLevel,
                activeColor: ProjectColors.forestGreen,
                onChanged: onActivityLevelChanged,
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
    required this.onGoalChanged,
  });

  final List<String> goals;
  final String? goal;
  final void Function(String?) onGoalChanged;

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
                title: Text(
                  g,
                  style: context.textTheme().bodyLarge?.copyWith(
                        color: ProjectColors.black,
                      ),
                ),
                value: g,
                groupValue: goal,
                activeColor: ProjectColors.forestGreen,
                onChanged: onGoalChanged,
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
    required this.onBudgetChanged,
  });

  final List<String> budgets;
  final String? budget;
  final void Function(String?) onBudgetChanged;

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
                  style: context.textTheme().bodyLarge?.copyWith(
                        color: ProjectColors.black,
                      ),
                ),
                value: b,
                groupValue: budget,
                activeColor: ProjectColors.forestGreen,
                onChanged: onBudgetChanged,
              ),
              if (b != budgets.last) const Divider(height: 1),
            ],
          );
        }).toList(),
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
