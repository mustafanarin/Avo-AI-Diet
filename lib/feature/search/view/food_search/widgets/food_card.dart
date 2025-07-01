part of '../search_view.dart';

class _FoodCard extends StatelessWidget {
  const _FoodCard({
    required this.food,
    required this.onTap,
  });

  final FoodModel food;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          children: [
            _FoodListTile(food: food),
            _NutritionRow(food: food),
          ],
        ),
      ),
    );
  }
}

class _FoodListTile extends StatelessWidget {
  const _FoodListTile({required this.food});

  final FoodModel food;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _FoodIcon(food: food),
      title: Text(
        food.name,
        style: context.textTheme().titleMedium,
      ),
      subtitle: Text(
        food.unitType == 'gram' 
            ? ProjectStrings.oneHundredGram 
            : '1 ${food.unitType}',
        style: context.textTheme().bodySmall?.copyWith(
          color: ProjectColors.grey600,
        ),
      ),
      trailing: _CalorieBadge(calorie: food.calorie),
    );
  }
}

class _FoodIcon extends StatelessWidget {
  const _FoodIcon({required this.food});

  final FoodModel food;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: ProjectColors.successGreen.withValues(alpha: 0.3),
      ),
      child: Icon(
        food.getIconData(),
        color: ProjectColors.forestGreen,
        size: 30.sp,
      ),
    );
  }
}

class _CalorieBadge extends StatelessWidget {
  const _CalorieBadge({required this.calorie});

  final double calorie;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: ProjectColors.forestGreen.withValues(alpha: 0.1),
      ),
      child: Text(
        '${calorie} kcal',
        style: context.textTheme().titleMedium,
      ),
    );
  }
}

class _NutritionRow extends StatelessWidget {
  const _NutritionRow({required this.food});

  final FoodModel food;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NutritionInfoBox(
            icon: FontAwesomeIcons.drumstickBite,
            value: food.protein,
            color: ProjectColors.green,
          ),
          _NutritionInfoBox(
            icon: FontAwesomeIcons.breadSlice,
            value: food.carbohydrate,
            color: ProjectColors.sandyBrown,
          ),
          _NutritionInfoBox(
            icon: FontAwesomeIcons.droplet,
            value: food.fat,
            color: ProjectColors.shadow,
          ),
        ],
      ),
    );
  }
}

class _NutritionInfoBox extends StatelessWidget {
  const _NutritionInfoBox({
    required this.value,
    required this.icon,
    required this.color,
  });

  final double value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            '${value}g',
            style: context.textTheme().bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}