part of '../food_detail_view.dart';

class _CalorieCard extends StatelessWidget {
  const _CalorieCard({required this.calorieText});

  final String calorieText;

  @override
  Widget build(BuildContext context) {
    return _NutritionCard(
      title: ProjectStrings.allCalori,
      value: calorieText,
      color: ProjectColors.accentCoral,
      icon: Icons.local_fire_department,
    );
  }
}

class _NutritionValuesCard extends StatelessWidget {
  const _NutritionValuesCard({
    required this.proteinText,
    required this.carbohydrateText,
    required this.fatText,
  });

  final String proteinText;
  final String carbohydrateText;
  final String fatText;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ProjectStrings.foodValues,
            style: context.textTheme().titleMedium,
          ),
          SizedBox(height: 20.h),
          _NutrientRow(
            title: ProjectStrings.protein,
            value: proteinText,
            color: ProjectColors.green,
            icon: FontAwesomeIcons.drumstickBite,
          ),
          SizedBox(height: 16.h),
          _NutrientRow(
            title: ProjectStrings.carbohydrate,
            value: carbohydrateText,
            color: ProjectColors.sandyBrown,
            icon: FontAwesomeIcons.breadSlice,
          ),
          SizedBox(height: 16.h),
          _NutrientRow(
            title: ProjectStrings.oil,
            value: fatText,
            color: ProjectColors.shadow,
            icon: FontAwesomeIcons.droplet,
          ),
        ],
      ),
    );
  }
}

class _NutritionCard extends StatelessWidget {
  const _NutritionCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String title;
  final String value;
  final Color color;
  final IconData icon;

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
      child: Row(
        children: [
          _NutritionIcon(color: color, icon: icon),
          SizedBox(width: 16.w),
          _NutritionInfo(title: title, value: value),
        ],
      ),
    );
  }
}

class _NutritionIcon extends StatelessWidget {
  const _NutritionIcon({
    required this.color,
    required this.icon,
  });

  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class _NutritionInfo extends StatelessWidget {
  const _NutritionInfo({
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}

class _NutrientRow extends StatelessWidget {
  const _NutrientRow({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String title;
  final String value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
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