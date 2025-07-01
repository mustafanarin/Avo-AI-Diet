import 'package:avo_ai_diet/feature/home/cubit/ai_diet_advice_cubit.dart';
import 'package:avo_ai_diet/feature/onboarding/cubit/user_info_cache_cubit.dart';
import 'package:avo_ai_diet/feature/onboarding/cubit/user_info_cubit.dart';
import 'package:avo_ai_diet/feature/onboarding/state/user_info_cache_state.dart';
import 'package:avo_ai_diet/feature/onboarding/state/user_info_state.dart';
import 'package:avo_ai_diet/feature/profile/view/user_info_edit/mixin/user_info_edit_mixin.dart';
import 'package:avo_ai_diet/product/constants/enum/custom/hero_lottie_enum.dart';
import 'package:avo_ai_diet/product/constants/enum/general/json_name.dart';
import 'package:avo_ai_diet/product/constants/enum/project_settings/app_durations.dart';
import 'package:avo_ai_diet/product/constants/enum/project_settings/app_padding.dart';
import 'package:avo_ai_diet/product/constants/project_colors.dart';
import 'package:avo_ai_diet/product/constants/project_strings.dart';
import 'package:avo_ai_diet/product/utility/extensions/activity_level_extension.dart';
import 'package:avo_ai_diet/product/utility/extensions/budget_extension.dart';
import 'package:avo_ai_diet/product/utility/extensions/goal_extension.dart';
import 'package:avo_ai_diet/product/utility/extensions/json_extension.dart';
import 'package:avo_ai_diet/product/utility/extensions/text_theme_extension.dart';
import 'package:avo_ai_diet/product/utility/init/service_locator.dart';
import 'package:avo_ai_diet/product/utility/validator/calori_validators.dart';
import 'package:avo_ai_diet/product/widgets/project_button.dart';
import 'package:avo_ai_diet/product/widgets/project_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

part './widgets/appbar.dart';
part './widgets/selection_item.dart';
part './widgets/steps.dart';

final class UserInfoEditView extends StatefulWidget {
  const UserInfoEditView({super.key});
  @override
  State<UserInfoEditView> createState() => _UserInfoEditViewState();
}

class _UserInfoEditViewState extends State<UserInfoEditView> with UserInfoEditMixin {
  @override
  void dispose() {
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<UserInfoCubit>()),
        BlocProvider(
          create: (context) {
            final cubit = getIt<UserInfoCacheCubit>()..loadUserInfo();
            return cubit;
          },
        ),
      ],
      child: BlocListener<UserInfoCacheCubit, UserInfoCacheState>(
        listener: (context, cacheState) {
          if (cacheState.cacheModel != null && !cacheState.isLoading) {
            final userInfo = cacheState.cacheModel!;

            if (userInfo.age.isNotEmpty) {
              ageController.text = userInfo.age;
            }

            if (userInfo.height.isNotEmpty) {
              heightController.text = userInfo.height;
            }

            if (userInfo.weight.isNotEmpty) {
              weightController.text = userInfo.weight;
            }

            if (userInfo.gender.isNotEmpty) {
              setState(() {
                gender = userInfo.gender;
              });
            }
          }
        },
        child: Builder(
          builder: (context) {
            return BlocBuilder<UserInfoCacheCubit, UserInfoCacheState>(
              builder: (context, cacheState) {
                if (cacheState.isLoading) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }

                return BlocConsumer<UserInfoCubit, UserInfoState>(
                  listener: (context, state) {
                    if (state.error != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.error!)),
                      );
                    }

                    // Navigation handling
                    if (state.isNavigating && state.response != null) {
                      final totalCalories = calculateTotalCalories();

                      context.read<AiDietAdviceCubit>().refreshDietPlan();

                      // Delay for hero animation to appear
                      Future.delayed(AppDurations.xLargeMilliseconds(), () {
                        if (mounted) {
                          navigateToHome(
                            context,
                            userName: '',
                            targetCal: totalCalories,
                          );
                        }
                      });
                    }
                  },
                  builder: (context, state) {
                    final cubit = context.read<UserInfoCubit>();
                    return state.isLoading
                        ? Scaffold(
                            body: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Hero(
                                    tag: HeroLottie.avoLottie.value,
                                    child: Lottie.asset(
                                      JsonName.avoWalk.path,
                                      height: 300.h,
                                      fit: BoxFit.cover,
                                    ),
                                  ),

                                  // Enhanced loading message
                                  AnimatedSwitcher(
                                    duration: AppDurations.mediumMilliseconds(),
                                    child: Column(
                                      key: ValueKey(state.isNavigating),
                                      children: [
                                        Text(
                                          state.isNavigating ? 'Hazır ✅' : ProjectStrings.avoDietLoadingMessage,
                                          style: context.textTheme().bodyLarge?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 100.h),
                                ],
                              ),
                            ),
                          )
                        : Scaffold(
                            appBar: const _CustomAppbar(),
                            body: Form(
                              key: formKey,
                              child: Stepper(
                                currentStep: currentStep,
                                elevation: 0,
                                onStepTapped: (step) {
                                  if (step < currentStep) {
                                    setState(() => currentStep = step);
                                  }
                                },
                                controlsBuilder: (context, details) {
                                  return Padding(
                                    padding: AppPadding.onlyTopXmedium(),
                                    child: Column(
                                      children: [
                                        ProjectButton(
                                          text: currentStep == 3
                                              ? ProjectStrings.calculatButton
                                              : ProjectStrings.continueButton,
                                          onPressed: !validateCurrentStep() || state.isLoading
                                              ? null
                                              : () {
                                                  if (currentStep < 3) {
                                                    setState(() => currentStep += 1);
                                                  } else {
                                                    userInfoCache(context);
                                                    submitForm(context, cubit);
                                                  }
                                                },
                                          isEnabled: validateCurrentStep() && !state.isLoading,
                                        ),
                                        if (currentStep > 0) ...[
                                          SizedBox(height: 12.h),
                                          BackButton(
                                            onPressed: () {
                                              setState(() => currentStep -= 1);
                                            },
                                          ),
                                        ],
                                      ],
                                    ),
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
                                      onGenderChanged: (value) => setState(() => gender = value),
                                      ageController: ageController,
                                      validators: validators,
                                      heightController: heightController,
                                      weightController: weightController,
                                    ),
                                    isActive: currentStep >= 0,
                                  ),
                                  Step(
                                    state: getStepState(1),
                                    title: Text(
                                      ProjectStrings.activityLevel,
                                      style: context.textTheme().titleMedium,
                                    ),
                                    content: ActivityLevelStep(
                                      activityLevels: ActivityLevelExtension.allDisplayNames,
                                      activityLevel: activityLevel,
                                      onActivityLevelChanged: (value) => setState(() => activityLevel = value),
                                    ),
                                    isActive: currentStep >= 1,
                                  ),
                                  Step(
                                    state: getStepState(2),
                                    title: Text(
                                      ProjectStrings.target,
                                      style: context.textTheme().titleMedium,
                                    ),
                                    content: _CaloriTargetStep(
                                      goals: GoalExtension.allDisplayNames,
                                      goal: goal,
                                      onGoalChanged: (value) => setState(() => goal = value),
                                    ),
                                    isActive: currentStep >= 2,
                                  ),
                                  Step(
                                    state: getStepState(3),
                                    title: Text(
                                      ProjectStrings.budget,
                                      style: context.textTheme().titleMedium,
                                    ),
                                    content: _BudgetStep(
                                      budgets: BudgetExtension.allDisplayNames,
                                      budget: budget,
                                      onBudgetChanged: (value) => setState(() => budget = value),
                                    ),
                                    isActive: currentStep >= 3,
                                  ),
                                ],
                              ),
                            ),
                          );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
