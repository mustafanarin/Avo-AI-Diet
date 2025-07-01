import 'package:avo_ai_diet/feature/onboarding/cubit/name_and_cal_cubit.dart';
import 'package:avo_ai_diet/feature/onboarding/cubit/user_info_cache_cubit.dart';
import 'package:avo_ai_diet/feature/onboarding/cubit/user_info_cubit.dart';
import 'package:avo_ai_diet/feature/onboarding/model/user_info_model.dart';
import 'package:avo_ai_diet/feature/profile/view/user_info_edit/user_info_edit_view.dart';
import 'package:avo_ai_diet/product/cache/model/name_calori/name_and_cal.dart';
import 'package:avo_ai_diet/product/cache/model/user_info/user_info_cache_model.dart';
import 'package:avo_ai_diet/product/constants/route_names.dart';
import 'package:avo_ai_diet/product/utility/extensions/activity_level_extension.dart';
import 'package:avo_ai_diet/product/utility/validator/calori_validators.dart';
import 'package:avo_ai_diet/services/calori_calculator_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

mixin UserInfoEditMixin on State<UserInfoEditView> {
  final formKey = GlobalKey<FormState>();
  final validators = CalorieValidators();
  int currentStep = 0;

  final ageController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();

  String? gender;
  String? activityLevel;
  String? goal;
  String? budget;

  @override
  void dispose() {
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    super.dispose();
  }

  // Check validation of each step
  bool validateCurrentStep() {
    switch (currentStep) {
      case 0:
        return gender != null &&
            validators.validateAge(ageController.text) == null &&
            validators.validateHeight(heightController.text) == null &&
            validators.validateWeight(weightController.text) == null;
      case 1:
        return activityLevel != null;
      case 2:
        return goal != null;
      case 3:
        return budget != null;
      default:
        return false;
    }
  }

  // Check the status of the stepper
  StepState getStepState(int step) {
    if (currentStep > step) return StepState.complete;
    if (currentStep == step) return StepState.editing;
    return StepState.disabled;
  }

  double calculateTotalCalories() {
    final weight = double.parse(weightController.text);
    final height = double.parse(heightController.text);
    final age = double.parse(ageController.text);

    final bmr = CalorieCalculatorService.calculateBMR(
      gender: gender!,
      weight: weight,
      height: height,
      age: age,
    );

    final selectedActivity = ActivityLevelExtension.fromDisplayName(activityLevel!);

    return CalorieCalculatorService.calculateTotalCalories(
      bmr: bmr,
      activityLevel: selectedActivity,
      goalDisplayName: goal!,
    );
  }

  Future<void> submitForm(BuildContext context, UserInfoCubit cubit) async {
    if (!validateCurrentStep()) return;

    final totalCalories = calculateTotalCalories();

    final userInfo = UserInfoModel(
      height: double.parse(heightController.text),
      weight: double.parse(weightController.text),
      age: double.parse(ageController.text),
      gender: gender!,
      activityLevel: activityLevel!,
      target: goal!,
      budget: budget!,
      targetCalories: totalCalories,
    );

    await cubit.submitUserInfo(userInfo);
  }

  Future<void> userInfoCache(BuildContext context) async {
    final cacheCubit = context.read<UserInfoCacheCubit>();
    final userInfoCache = UserInfoCacheModel(
      gender: gender ?? '',
      age: ageController.text,
      height: heightController.text,
      weight: weightController.text,
    );

    await cacheCubit.saveUserInfo(userInfoCache);
  }

  void navigateToHome(
    BuildContext context, {
    required String userName,
    required double targetCal,
  }) {
    if (!mounted) return;

    final cubit = context.read<NameAndCalCubit>();
    final nameAndCal = NameAndCalModel(userName: cubit.state.name ?? '', targetCal: targetCal);

    cubit.submitNameAndCal(nameAndCal);

    context.pushReplacement(RouteNames.tabbarWithIndexPath(0));
  }
}
