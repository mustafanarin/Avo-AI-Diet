final class DailyCalorieState {
  DailyCalorieState({
    this.currentCalories = 0,
    this.lastResetDate,
    this.isLoading = false,
  });

  final int currentCalories;
  final String? lastResetDate;
  final bool isLoading;

  DailyCalorieState copyWith({
    int? currentCalories,
    String? lastResetDate,
    bool? isLoading,
  }) {
    return DailyCalorieState(
      currentCalories: currentCalories ?? this.currentCalories,
      lastResetDate: lastResetDate ?? this.lastResetDate,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}