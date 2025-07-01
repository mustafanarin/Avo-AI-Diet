part of '../food_detail_view.dart';

class _QuantityControls extends StatelessWidget {
  const _QuantityControls({
    required this.quantityController,
    required this.foodModel,
    required this.onIncrement,
    required this.onDecrement,
    required this.onTextFieldSubmitted,
    required this.incrementLabel,
    required this.decrementLabel,
    required this.maxInputLength,
  });

  final TextEditingController quantityController;
  final FoodModel foodModel;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final Function(String) onTextFieldSubmitted;
  final String incrementLabel;
  final String decrementLabel;
  final int maxInputLength;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          _QuantityTitle(),
          SizedBox(height: 12.h),
          _QuantityRow(
            quantityController: quantityController,
            foodModel: foodModel,
            onIncrement: onIncrement,
            onDecrement: onDecrement,
            onTextFieldSubmitted: onTextFieldSubmitted,
            incrementLabel: incrementLabel,
            decrementLabel: decrementLabel,
            maxInputLength: maxInputLength,
          ),
        ],
      ),
    );
  }
}

class _QuantityTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Miktar',
      style: context.textTheme().titleMedium,
    );
  }
}

class _QuantityRow extends StatelessWidget {
  const _QuantityRow({
    required this.quantityController,
    required this.foodModel,
    required this.onIncrement,
    required this.onDecrement,
    required this.onTextFieldSubmitted,
    required this.incrementLabel,
    required this.decrementLabel,
    required this.maxInputLength,
  });

  final TextEditingController quantityController;
  final FoodModel foodModel;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final Function(String) onTextFieldSubmitted;
  final String incrementLabel;
  final String decrementLabel;
  final int maxInputLength;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        _QuantityButton(
          icon: Icons.remove,
          onPressed: onDecrement,
          label: decrementLabel,
        ),
        const Spacer(),
        Expanded(
          flex: 4,
          child: _QuantityTextField(
            quantityController: quantityController,
            foodModel: foodModel,
            onSubmitted: onTextFieldSubmitted,
            maxInputLength: maxInputLength,
          ),
        ),
        const Spacer(),
        _QuantityButton(
          icon: Icons.add,
          onPressed: onIncrement,
          label: incrementLabel,
        ),
        const Spacer(),
      ],
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.icon,
    required this.onPressed,
    required this.label,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
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
}

class _QuantityTextField extends StatelessWidget {
  const _QuantityTextField({
    required this.quantityController,
    required this.foodModel,
    required this.onSubmitted,
    required this.maxInputLength,
  });

  final TextEditingController quantityController;
  final FoodModel foodModel;
  final Function(String) onSubmitted;
  final int maxInputLength;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        color: ProjectColors.successGreen.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: ProjectColors.lightGreen.withValues(alpha: 0.3),
        ),
      ),
      child: TextField(
        controller: quantityController,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(maxInputLength),
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 8.h),
          suffix: Text(
            foodModel.unitType,
            style: context.textTheme().bodySmall,
          ),
        ),
        style: context.textTheme().bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
        onSubmitted: onSubmitted,
      ),
    );
  }
}
