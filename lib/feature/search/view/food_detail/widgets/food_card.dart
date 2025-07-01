part of '../food_detail_view.dart';

class _FoodInfoCard extends StatelessWidget {
  const _FoodInfoCard({
    required this.foodModel,
    required this.quantityDisplayText,
  });

  final FoodModel foodModel;
  final String quantityDisplayText;

  @override
  Widget build(BuildContext context) {
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
      child: Column(
        children: [
          _FoodAvatar(foodModel: foodModel),
          SizedBox(height: 16.h),
          _FoodTitle(foodModel: foodModel),
          SizedBox(height: 8.h),
          _FoodQuantity(quantityDisplayText: quantityDisplayText),
        ],
      ),
    );
  }
}

class _FoodAvatar extends StatelessWidget {
  const _FoodAvatar({required this.foodModel});

  final FoodModel foodModel;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 45.r,
      backgroundColor: ProjectColors.successGreen.withValues(alpha: 0.3),
      child: Icon(
        foodModel.getIconData(),
        size: 40,
        color: ProjectColors.forestGreen,
      ),
    );
  }
}

class _FoodTitle extends StatelessWidget {
  const _FoodTitle({required this.foodModel});

  final FoodModel foodModel;

  @override
  Widget build(BuildContext context) {
    return Text(
      foodModel.name,
      style: context.textTheme().displayLarge,
      textAlign: TextAlign.center,
    );
  }
}

class _FoodQuantity extends StatelessWidget {
  const _FoodQuantity({required this.quantityDisplayText});

  final String quantityDisplayText;

  @override
  Widget build(BuildContext context) {
    return Text(
      quantityDisplayText,
      style: context.textTheme().bodyLarge?.copyWith(
        color: ProjectColors.grey600,
      ),
    );
  }
}