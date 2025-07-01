part of '../user_info_edit_view.dart';

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
        Row(
          children: [
            Expanded(
              child: _SelectionItem(
                title: ProjectStrings.male,
                isSelected: gender == ProjectStrings.male,
                onTap: () => onGenderChanged(ProjectStrings.male),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _SelectionItem(
                title: ProjectStrings.female,
                isSelected: gender == ProjectStrings.female,
                onTap: () => onGenderChanged(ProjectStrings.female),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        ProjectTextField(
          controller: ageController,
          labelText: ProjectStrings.age,
          validator: validators.validateAge,
          keyboardType: TextInputType.number,
          onChanged: (_) => onGenderChanged(gender),
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

class ActivityLevelStep extends StatelessWidget {
  const ActivityLevelStep({
    required this.activityLevels,
    required this.activityLevel,
    required this.onActivityLevelChanged,
    super.key,
  });

  final List<String> activityLevels;
  final String? activityLevel;
  final void Function(String?) onActivityLevelChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: activityLevels.map((level) {
        return _SelectionItem(
          title: level,
          isSelected: activityLevel == level,
          onTap: () => onActivityLevelChanged(level),
        );
      }).toList(),
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
    return Column(
      children: goals.map((g) {
        return _SelectionItem(
          title: g,
          isSelected: goal == g,
          onTap: () => onGoalChanged(g),
        );
      }).toList(),
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
    return Column(
      children: budgets.map((b) {
        return _SelectionItem(
          title: b,
          isSelected: budget == b,
          onTap: () => onBudgetChanged(b),
        );
      }).toList(),
    );
  }
}
