import 'package:avo_ai_diet/feature/search/model/food_model.dart';
import 'package:avo_ai_diet/product/constants/project_colors.dart';
import 'package:avo_ai_diet/product/constants/project_strings.dart';
import 'package:avo_ai_diet/product/utility/extensions/text_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FoodDetailPage extends StatefulWidget {
  const FoodDetailPage({required this.foodModel, super.key});
  final FoodModel foodModel;

  @override
  State<FoodDetailPage> createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailPage> {
  double quantity = 100; // Initial quantity is 100 grams
  late double calculatedCalorie;
  late double calculatedProtein;
  late double calculatedCarbohydrate;
  late double calculatedFat;

  void updateNutritionValues() {
    // Update nutrition values based on the quantity ratio
    final ratio = quantity / 100.0;
    calculatedCalorie = widget.foodModel.calorie * ratio;
    calculatedProtein = widget.foodModel.protein * ratio;
    calculatedCarbohydrate = widget.foodModel.carbohydrate * ratio;
    calculatedFat = widget.foodModel.fat * ratio;
  }

  TextEditingController quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
        // Ensure quantity is between 1 and 999
        if (newQuantity > 999) {
          newQuantity = 999;
          quantityController.text = '999';
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

  void incrementQuantity() {
    // Don't increase beyond 999 grams
    if (quantity < 999) {
      setState(() {
        // If adding 10 would exceed 999, just set to 999
        quantity = (quantity + 10 > 999) ? 999 : quantity + 10;
        quantityController.text = quantity.toStringAsFixed(0);
        updateNutritionValues();
      });
    }
  }

  void decrementQuantity() {
    if (quantity > 10) {
      setState(() {
        quantity -= 10; // Decrease by 10 grams
        quantityController.text = quantity.toStringAsFixed(0);
        updateNutritionValues();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              // Food Name and Icon
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24.r),
                decoration: BoxDecoration(
                  color: ProjectColors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: ProjectColors.black.withOpacity(0.05),
                      blurRadius: 10.r,
                      offset: Offset(0, 4.h),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 45.r,
                      backgroundColor: ProjectColors.primary.withOpacity(0.2),
                      child: const Icon(
                        Icons.restaurant,
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
                      '${quantity.toStringAsFixed(0)} gram',
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
                      color: ProjectColors.black.withOpacity(0.05),
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
                        // -10g button
                        const Spacer(),
                        _buildQuantityButton(
                          icon: Icons.remove,
                          onPressed: decrementQuantity,
                          label: '-10g',
                        ),
                        const Spacer(),
                        Expanded(
                          flex: 4,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 8.w),
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            decoration: BoxDecoration(
                              color: ProjectColors.primary.withOpacity(0.2),
                              //   Color(0xFFEDF6EC)
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(color: ProjectColors.lightGreen.withOpacity(0.3)),
                            ),
                            child: TextField(
                              controller: quantityController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              // Limit input to 3 digits (max 999)
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(3),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                                suffix: Text(
                                  'g',
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
                                    // Apply limits when submitting as well
                                    if (newQuantity > 999) {
                                      newQuantity = 999;
                                      quantityController.text = '999';
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
                        // +10g button
                        _buildQuantityButton(
                          icon: Icons.add,
                          onPressed: incrementQuantity,
                          label: '+10g',
                        ),
                        const Spacer(),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // Kalori Bilgisi
              _buildNutritionCard(
                context: context,
                title: ProjectStrings.allCalori,
                value: '${calculatedCalorie.toStringAsFixed(1)} kcal',
                color: ProjectColors.accentCoral,
                icon: Icons.local_fire_department,
              ),

              SizedBox(height: 24.h),

              // Nutrition Values
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24.r),
                decoration: BoxDecoration(
                  color: ProjectColors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: ProjectColors.black.withOpacity(0.05),
                      blurRadius: 10.r,
                      offset: Offset(0, 4.h),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Besin Değerleri',
                      style: context.textTheme().titleMedium,
                    ),
                    SizedBox(height: 20.h),
                    // Protein information
                    _buildNutrientRow(
                      context: context,
                      title: 'Protein',
                      value: '${calculatedProtein.toStringAsFixed(1)}g',
                      color: const Color(0xFF6CB4EE),
                      icon: Icons.health_and_safety,
                    ),
                    SizedBox(height: 16.h),
                    // Carbohydrate information
                    _buildNutrientRow(
                      context: context,
                      title: 'Karbonhidrat',
                      value: '${calculatedCarbohydrate.toStringAsFixed(1)}g',
                      color: ProjectColors.mainAvocado,
                      icon: Icons.grain,
                    ),
                    SizedBox(height: 16.h),
                    // Fat information
                    _buildNutrientRow(
                      context: context,
                      title: 'Yağ',
                      value: '${calculatedFat.toStringAsFixed(1)}g',
                      color: ProjectColors.seedBeige,
                      icon: Icons.opacity,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),
            ],
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
              color: ProjectColors.forestGreen,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              icon,
              color: ProjectColors.white,
              size: 20,
            ),
          ),
          if (label != null)
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: ProjectColors.grey600,
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
            color: ProjectColors.black.withOpacity(0.05),
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
              color: color.withOpacity(0.2),
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
                style: context.textTheme().titleMedium?.copyWith(
                      color: ProjectColors.darkAvocado,
                      fontSize: 20,
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
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
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
