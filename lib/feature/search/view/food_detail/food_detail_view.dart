import 'package:avo_ai_diet/feature/search/model/food_model.dart';
import 'package:avo_ai_diet/feature/search/view/food_detail/mixin/food_detail_mixin.dart';
import 'package:avo_ai_diet/product/constants/project_colors.dart';
import 'package:avo_ai_diet/product/constants/project_strings.dart';
import 'package:avo_ai_diet/product/utility/extensions/icon_data_extension.dart';
import 'package:avo_ai_diet/product/utility/extensions/text_theme_extension.dart';
import 'package:avo_ai_diet/product/widgets/project_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

part './widgets/calorie_card.dart';
part './widgets/food_card.dart';
part './widgets/quantity_controls.dart';

final class FoodDetailPage extends StatefulWidget {
  const FoodDetailPage({required this.foodModel, super.key});

  final FoodModel foodModel;

  @override
  State<FoodDetailPage> createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailPage> with FoodDetailPageMixin {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => onWillPop(),
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FoodInfoCard(
                  foodModel: foodModel,
                  quantityDisplayText: getQuantityDisplayText(),
                ),
                SizedBox(height: 24.h),
                _QuantityControls(
                  quantityController: quantityController,
                  foodModel: foodModel,
                  onIncrement: incrementQuantity,
                  onDecrement: decrementQuantity,
                  onTextFieldSubmitted: onQuantityTextFieldSubmitted,
                  incrementLabel: getIncrementButtonLabel(),
                  decrementLabel: getDecrementButtonLabel(),
                  maxInputLength: getMaxInputLength(),
                ),
                SizedBox(height: 24.h),
                _CalorieCard(
                  calorieText: getCalorieDisplayText(),
                ),
                SizedBox(height: 24.h),
                _NutritionValuesCard(
                  proteinText: getProteinDisplayText(),
                  carbohydrateText: getCarbohydrateDisplayText(),
                  fatText: getFatDisplayText(),
                ),
                SizedBox(height: 24.h),
                ProjectButton(
                  text: 'Ekle',
                  onPressed: () => onAddButtonPressed(context),
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        ProjectStrings.foodDetail,
        style: context.textTheme().titleLarge,
      ),
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: ProjectColors.earthBrown,
          size: 24,
        ),
        onPressed: () => onBackButtonPressed(context),
      ),
    );
  }
}
