import 'package:avo_ai_diet/feature/home/cubit/daily_calorie_cubit.dart';
import 'package:avo_ai_diet/feature/onboarding/cubit/name_and_cal_cubit.dart';
import 'package:avo_ai_diet/feature/search/model/food_model.dart';
import 'package:avo_ai_diet/feature/search/view/food_detail/food_detail_view.dart';
import 'package:avo_ai_diet/product/widgets/project_toast_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

mixin FoodDetailPageMixin on State<FoodDetailPage> {
  // Controllers
  late final TextEditingController quantityController;

  // State variables
  double _quantity = 1;
  late double _calculatedCalorie;
  late double _calculatedProtein;
  late double _calculatedCarbohydrate;
  late double _calculatedFat;

  // Getters
  double get quantity => _quantity;
  double get calculatedCalorie => _calculatedCalorie;
  double get calculatedProtein => _calculatedProtein;
  double get calculatedCarbohydrate => _calculatedCarbohydrate;
  double get calculatedFat => _calculatedFat;

  FoodModel get foodModel => widget.foodModel;

  @override
  void initState() {
    super.initState();
    _initializeQuantityController();
    _setInitialQuantity();
    _updateNutritionValues();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  // Initialization methods
  void _initializeQuantityController() {
    quantityController = TextEditingController();
    quantityController.addListener(_updateFromTextField);
  }

  void _setInitialQuantity() {
    _quantity = foodModel.unitType == 'gram' ? 100.0 : 1.0;
    quantityController.text = _quantity.toStringAsFixed(0);
  }

  void _disposeControllers() {
    quantityController.removeListener(_updateFromTextField);
    quantityController.dispose();
  }

  // Quantity management
  void incrementQuantity() {
    if (foodModel.unitType == 'gram') {
      _incrementGramQuantity();
    } else {
      _incrementPieceQuantity();
    }
  }

  void decrementQuantity() {
    if (foodModel.unitType == 'gram') {
      _decrementGramQuantity();
    } else {
      _decrementPieceQuantity();
    }
  }

  void _incrementGramQuantity() {
    if (_quantity < 999) {
      final newQuantity = (_quantity + 10 > 999) ? 999.0 : _quantity + 10;
      _updateQuantity(newQuantity);
    }
  }

  void _decrementGramQuantity() {
    if (_quantity > 10) {
      _updateQuantity(_quantity - 10);
    }
  }

  void _incrementPieceQuantity() {
    if (_quantity < 10) {
      _updateQuantity(_quantity + 1);
    }
  }

  void _decrementPieceQuantity() {
    if (_quantity > 1) {
      _updateQuantity(_quantity - 1);
    }
  }

  void _updateQuantity(double newQuantity) {
    setState(() {
      _quantity = newQuantity;
      quantityController.text = _quantity.toStringAsFixed(0);
      _updateNutritionValues();
    });
  }

  // Text field updates
  void _updateFromTextField() {
    if (quantityController.text.isEmpty) return;

    try {
      var newQuantity = double.parse(quantityController.text);

      newQuantity = _validateAndLimitQuantity(newQuantity);

      if (newQuantity > 0) {
        setState(() {
          _quantity = newQuantity;
          _updateNutritionValues();
        });
      }
    } catch (e) {
      // Do nothing for non-numeric inputs
    }
  }

  double _validateAndLimitQuantity(double quantity) {
    // Prevent zero or negative values
    if (quantity <= 0) {
      final defaultValue = foodModel.unitType == 'gram' ? 100.0 : 1.0;
      quantityController.text = defaultValue.toStringAsFixed(0);
      return defaultValue;
    }

    // Apply limits based on unit type
    if (foodModel.unitType == 'gram') {
      if (quantity > 999) {
        quantityController.text = '999';
        return 999;
      }
    } else {
      if (quantity > 10) {
        quantityController.text = '10';
        return 10;
      }
    }

    return quantity;
  }

  // Nutrition calculations
  void _updateNutritionValues() {
    if (foodModel.unitType == 'gram') {
      _calculateGramBasedNutrition();
    } else {
      _calculatePieceBasedNutrition();
    }
  }

  void _calculateGramBasedNutrition() {
    // For gram-based foods, calculate relative to 100g
    final ratio = _quantity / 100.0;
    _calculatedCalorie = foodModel.calorie * ratio;
    _calculatedProtein = foodModel.protein * ratio;
    _calculatedCarbohydrate = foodModel.carbohydrate * ratio;
    _calculatedFat = foodModel.fat * ratio;
  }

  void _calculatePieceBasedNutrition() {
    // For piece, slice, spoon etc., multiply directly
    _calculatedCalorie = foodModel.calorie * _quantity;
    _calculatedProtein = foodModel.protein * _quantity;
    _calculatedCarbohydrate = foodModel.carbohydrate * _quantity;
    _calculatedFat = foodModel.fat * _quantity;
  }

  // User interactions
  void onQuantityTextFieldSubmitted(String value) {
    if (value.isEmpty) return;

    try {
      var newQuantity = double.parse(value);

      // Apply limits based on unit type
      if (foodModel.unitType == 'gram') {
        if (newQuantity > 999) {
          newQuantity = 999.0;
          quantityController.text = '999';
        }
      } else {
        if (newQuantity > 99) {
          newQuantity = 99.0;
          quantityController.text = '99';
        }
      }

      if (newQuantity > 0) {
        setState(() {
          _quantity = newQuantity;
          _updateNutritionValues();
        });
      }
    } catch (e) {
      quantityController.text = _quantity.toStringAsFixed(0);
    }
  }

  void onAddButtonPressed(BuildContext context) {
    final targetCalories = context.read<NameAndCalCubit>().state.targetCal ?? 2500;

    // Add calories to daily tracking
    context.read<DailyCalorieCubit>().addCalories(
          _calculatedCalorie.toInt(),
          targetCalories.toInt(),
        );

    // Show success message
    _showSuccessToast(context);

    // Close keyboard and navigate back
    _closeKeyboardAndNavigateBack(context);
  }

  void _showSuccessToast(BuildContext context) {
    ProjectToastMessage.show(
      context,
      '${_calculatedCalorie.toInt()} kalori günlük takibinize eklendi',
    );
  }

  void _closeKeyboardAndNavigateBack(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.of(context).pop();
  }

  // Helper methods for UI
  String getQuantityDisplayText() {
    return '${_quantity.toStringAsFixed(0)} ${foodModel.unitType}';
  }

  String getCalorieDisplayText() {
    return '${_calculatedCalorie.toStringAsFixed(1)} kcal';
  }

  String getProteinDisplayText() {
    return '${_calculatedProtein.toStringAsFixed(1)}g';
  }

  String getCarbohydrateDisplayText() {
    return '${_calculatedCarbohydrate.toStringAsFixed(1)}g';
  }

  String getFatDisplayText() {
    return '${_calculatedFat.toStringAsFixed(1)}g';
  }

  String getIncrementButtonLabel() {
    return foodModel.unitType == 'gram' ? '+10g' : '+1';
  }

  String getDecrementButtonLabel() {
    return foodModel.unitType == 'gram' ? '-10g' : '-1';
  }

  int getMaxInputLength() {
    return foodModel.unitType == 'gram' ? 3 : 1;
  }

  // Navigation helpers
  bool onWillPop() {
    FocusManager.instance.primaryFocus?.unfocus();
    return true;
  }

  void onBackButtonPressed(BuildContext context) {
    Navigator.of(context).pop();
  }
}
