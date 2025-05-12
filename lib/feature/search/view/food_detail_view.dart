import 'package:avo_ai_diet/feature/home/cubit/daily_calorie_cubit.dart';
import 'package:avo_ai_diet/feature/onboarding/cubit/name_and_cal_cubit.dart';
import 'package:avo_ai_diet/feature/search/model/food_model.dart';
import 'package:avo_ai_diet/product/constants/project_colors.dart';
import 'package:avo_ai_diet/product/constants/project_strings.dart';
import 'package:avo_ai_diet/product/utility/extensions/icon_data_extension.dart';
import 'package:avo_ai_diet/product/utility/extensions/text_theme_extension.dart';
import 'package:avo_ai_diet/product/widgets/project_button.dart';
import 'package:avo_ai_diet/product/widgets/project_toast_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final class FoodDetailPage extends StatefulWidget {
  const FoodDetailPage({required this.foodModel, super.key});
  final FoodModel foodModel;

  @override
  State<FoodDetailPage> createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailPage> {
  double quantity = 1; // Initial quantity
  late double calculatedCalorie;
  late double calculatedProtein;
  late double calculatedCarbohydrate;
  late double calculatedFat;

  TextEditingController quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set initial quantity based on unit type
    quantity = widget.foodModel.unitType == 'gram' ? 100 : 1;
    quantityController.text = quantity.toStringAsFixed(0);
    quantityController.addListener(_updateFromTextField);
    updateNutritionValues();
  }

  @override
  void dispose() {
    quantityController.dispose();
    super.dispose();
  }

  void _updateFromTextField() {
    if (quantityController.text.isNotEmpty) {
      try {
        var newQuantity = double.parse(quantityController.text);

        // Prevent zero or negative values
        if (newQuantity <= 0) {
          newQuantity = widget.foodModel.unitType == 'gram' ? 100 : 1;
          quantityController.text = newQuantity.toStringAsFixed(0);
        }

        // Check limits
        if (widget.foodModel.unitType == 'gram') {
          // For gram, between 1-999
          if (newQuantity > 999) {
            newQuantity = 999;
            quantityController.text = '999';
          }
        } else {
          // For piece/slice/spoon etc., between 1-10
          if (newQuantity > 10) {
            newQuantity = 10;
            quantityController.text = '10';
          }
        }

        if (newQuantity > 0) {
          setState(() {
            quantity = newQuantity;
            updateNutritionValues();
          });
        }
      } catch (e) {
        // Do nothing for non-numeric inputs
      }
    }
  }

  void updateNutritionValues() {
    if (widget.foodModel.unitType == 'gram') {
      // For gram-based foods, calculate relative to 100g
      final ratio = quantity / 100.0;
      calculatedCalorie = widget.foodModel.calorie * ratio;
      calculatedProtein = widget.foodModel.protein * ratio;
      calculatedCarbohydrate = widget.foodModel.carbohydrate * ratio;
      calculatedFat = widget.foodModel.fat * ratio;
    } else {
      // For piece, slice, spoon etc., multiply directly
      calculatedCalorie = widget.foodModel.calorie * quantity;
      calculatedProtein = widget.foodModel.protein * quantity;
      calculatedCarbohydrate = widget.foodModel.carbohydrate * quantity;
      calculatedFat = widget.foodModel.fat * quantity;
    }
  }

  void incrementQuantity() {
    if (widget.foodModel.unitType == 'gram') {
      // Increase by 10 grams for gram-based foods
      if (quantity < 999) {
        setState(() {
          quantity = (quantity + 10 > 999) ? 999 : quantity + 10;
          quantityController.text = quantity.toStringAsFixed(0);
          updateNutritionValues();
        });
      }
    } else {
      // Increase by 1 for piece-based foods
      if (quantity < 10) {
        setState(() {
          quantity += 1;
          quantityController.text = quantity.toStringAsFixed(0);
          updateNutritionValues();
        });
      }
    }
  }

  void decrementQuantity() {
    if (widget.foodModel.unitType == 'gram') {
      // Decrease by 10 grams for gram-based foods
      if (quantity > 10) {
        setState(() {
          quantity -= 10;
          quantityController.text = quantity.toStringAsFixed(0);
          updateNutritionValues();
        });
      }
    } else {
      // Decrease by 1 for piece-based foods
      if (quantity > 1) {
        setState(() {
          quantity -= 1;
          quantityController.text = quantity.toStringAsFixed(0);
          updateNutritionValues();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final targetCalories = context.select(
      (NameAndCalCubit cubit) => cubit.state.targetCal ?? 2500,
    );
    return WillPopScope(
      // Close keyboard when back button is pressed
      onWillPop: () async {
        FocusManager.instance.primaryFocus?.unfocus();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(ProjectStrings.foodDetail, style: context.textTheme().titleLarge),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: ProjectColors.earthBrown, size: 24),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(24.r),
                  decoration: BoxDecoration(
                    color: ProjectColors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: ProjectColors.black.withValues(alpha: 0.05),
                        blurRadius: 10.r,
                        offset: Offset(0, 4.h),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 45.r,
                        backgroundColor: ProjectColors.successGreen.withValues(alpha: 0.3),
                        child: Icon(
                          widget.foodModel.getIconData(),
                          size: 40,
                          color: ProjectColors.forestGreen,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        widget.foodModel.name,
                        style: context.textTheme().displayLarge,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '${quantity.toStringAsFixed(0)} ${widget.foodModel.unitType}',
                        style: context.textTheme().bodyLarge?.copyWith(
                              color: ProjectColors.grey600,
                            ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                // Advanced Quantity Controls
                Container(
                  decoration: BoxDecoration(
                    color: ProjectColors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: ProjectColors.black.withValues(alpha: 0.05),
                        blurRadius: 10.r,
                        offset: Offset(0, 4.h),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Miktar',
                        style: context.textTheme().titleMedium,
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          // Decrease button
                          const Spacer(),
                          _buildQuantityButton(
                            icon: Icons.remove,
                            onPressed: decrementQuantity,
                            label: widget.foodModel.unitType == 'gram' ? '-10g' : '-1',
                          ),
                          const Spacer(),
                          Expanded(
                            flex: 4,
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 8.w),
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              decoration: BoxDecoration(
                                color: ProjectColors.successGreen.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(color: ProjectColors.lightGreen.withValues(alpha: 0.3)),
                              ),
                              child: TextField(
                                controller: quantityController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                // Character limit based on unit type
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(
                                    widget.foodModel.unitType == 'gram' ? 3 : 1,
                                  ),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                                  suffix: Text(
                                    widget.foodModel.unitType,
                                    style: context.textTheme().bodySmall,
                                  ),
                                ),
                                style: context.textTheme().bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                onSubmitted: (value) {
                                  if (value.isNotEmpty) {
                                    try {
                                      var newQuantity = double.parse(value);
                                      // Apply limits based on unit type
                                      if (widget.foodModel.unitType == 'gram') {
                                        if (newQuantity > 999) {
                                          newQuantity = 999;
                                          quantityController.text = '999';
                                        }
                                      } else {
                                        if (newQuantity > 99) {
                                          newQuantity = 99;
                                          quantityController.text = '99';
                                        }
                                      }

                                      if (newQuantity > 0) {
                                        setState(() {
                                          quantity = newQuantity;
                                          updateNutritionValues();
                                        });
                                      }
                                    } catch (e) {
                                      quantityController.text = quantity.toStringAsFixed(0);
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                          const Spacer(),
                          // Increase button
                          _buildQuantityButton(
                            icon: Icons.add,
                            onPressed: incrementQuantity,
                            label: widget.foodModel.unitType == 'gram' ? '+10g' : '+1',
                          ),
                          const Spacer(),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                // Calorie Information
                _buildNutritionCard(
                  context: context,
                  title: ProjectStrings.allCalori,
                  value: '${calculatedCalorie.toStringAsFixed(1)} kcal',
                  color: ProjectColors.accentCoral,
                  icon: Icons.local_fire_department,
                ),

                SizedBox(height: 24.h),

                // Nutritional Values
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(24.r),
                  decoration: BoxDecoration(
                    color: ProjectColors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: ProjectColors.black.withValues(alpha: 0.05),
                        blurRadius: 10.r,
                        offset: Offset(0, 4.h),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ProjectStrings.foodValues,
                        style: context.textTheme().titleMedium,
                      ),
                      SizedBox(height: 20.h),
                      // Protein information
                      _buildNutrientRow(
                        context: context,
                        title: ProjectStrings.protein,
                        value: '${calculatedProtein.toStringAsFixed(1)}g',
                        color: ProjectColors.green,
                        icon: FontAwesomeIcons.drumstickBite,
                      ), //
                      SizedBox(height: 16.h),
                      // Carbohydrate information
                      _buildNutrientRow(
                        context: context,
                        title: ProjectStrings.carbohydrate,
                        value: '${calculatedCarbohydrate.toStringAsFixed(1)}g',
                        color: ProjectColors.sandyBrown,
                        icon: FontAwesomeIcons.breadSlice,
                      ),
                      SizedBox(height: 16.h),
                      // Fat information
                      _buildNutrientRow(
                        context: context,
                        title: ProjectStrings.oil,
                        value: '${calculatedFat.toStringAsFixed(1)}g',
                        color: ProjectColors.shadow,
                        icon: FontAwesomeIcons.droplet,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),
                ProjectButton(
                  text: 'Ekle',
                  onPressed: () {
                    context.read<DailyCalorieCubit>().addCalories(
                          calculatedCalorie.toInt(),
                          targetCalories.toInt(),
                        );

                    ProjectToastMessage.show(
                      context,
                      '${calculatedCalorie.toInt()} kalori günlük takibinize eklendi',
                    );

                    // Close all keyboards before returning
                    FocusManager.instance.primaryFocus?.unfocus();
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
    String? label,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: ProjectColors.lightGreen,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              icon,
              color: ProjectColors.white,
              size: 20.sp,
            ),
          ),
          if (label != null)
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Text(
                label,
                style: context.textTheme().bodySmall?.copyWith(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNutritionCard({
    required BuildContext context,
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: ProjectColors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: ProjectColors.black.withValues(alpha: 0.05),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.textTheme().bodyMedium,
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                style: context.textTheme().titleLarge?.copyWith(
                      color: ProjectColors.forestGreen,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientRow({
    required BuildContext context,
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20.sp,
          ),
        ),
        SizedBox(width: 12.w),
        Text(
          title,
          style: context.textTheme().bodyMedium,
        ),
        const Spacer(),
        Text(
          value,
          style: context.textTheme().bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
