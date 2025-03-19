import 'package:avo_ai_diet/feature/home/state/daily_calorie_state.dart';
import 'package:avo_ai_diet/product/cache/manager/daily_calorie/daily_calorie_manager.dart';
import 'package:avo_ai_diet/product/cache/model/daily_calorie/daily_calorie_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
final class DailyCalorieCubit extends Cubit<DailyCalorieState> {
  DailyCalorieCubit(this._calorieManager) : super(DailyCalorieState());
  final DailyCalorieManager _calorieManager;

  Future<void> initialize() async {
    emit(state.copyWith(isLoading: true));
    try {
      final storedData = await _calorieManager.getCalorieData();
      emit(
        state.copyWith(
          currentCalories: storedData.currentCalories,
          lastResetDate: storedData.lastResetDate,
          isLoading: false,
        ),
      );
      // Date check
      await checkDateChange();
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> addCalories(int amount, int maxCalories) async {
    final newCalories = state.currentCalories + amount;
    // Should not exceed maximum value
    final calorieValue = newCalories > maxCalories ? maxCalories : newCalories;

    final now = DateTime.now();
    final todayStr = '${now.year}-${now.month}-${now.day}';

    emit(
      state.copyWith(
        currentCalories: calorieValue,
        lastResetDate: todayStr,
      ),
    );

    await _calorieManager.saveCalorieData(
      DailyCalorieModel(
        currentCalories: calorieValue,
        lastResetDate: todayStr,
      ),
    );
  }

  Future<void> setCalories(int amount, int maxCalories) async {
    final calorieValue = amount > maxCalories 
        ? maxCalories 
        : amount;
    
    final now = DateTime.now();
    final todayStr = "${now.year}-${now.month}-${now.day}";
    
    emit(state.copyWith(
      currentCalories: calorieValue,
      lastResetDate: todayStr
    ));
    
    await _calorieManager.saveCalorieData(DailyCalorieModel(
      currentCalories: calorieValue,
      lastResetDate: todayStr,
    ));
  }
  

  Future<void> checkDateChange() async {
    if (state.lastResetDate == null) return;

    final now = DateTime.now();
    final today = '${now.year}-${now.month}-${now.day}';

    // If date changed reset calories
    if (state.lastResetDate != today) {
      await resetCalories();
    }
  }

  Future<void> resetCalories() async {
    final now = DateTime.now();
    final today = '${now.year}-${now.month}-${now.day}';

    emit(state.copyWith(currentCalories: 0, lastResetDate: today));
    await _calorieManager.saveCalorieData(
      DailyCalorieModel(lastResetDate: today),
    );
  }
}
