part of '../user_info_edit_view.dart';

class _SelectionItem extends StatelessWidget {
  const _SelectionItem({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
          decoration: BoxDecoration(
            color: isSelected ? ProjectColors.mainAvocado.withValues(alpha: 0.2) : ProjectColors.backgroundCream,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? ProjectColors.mainAvocado : ProjectColors.grey400,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: ProjectColors.mainAvocado,
                  size: 20.sp,
                )
              else
                Icon(
                  Icons.circle_outlined,
                  color: ProjectColors.grey500,
                  size: 20.sp,
                ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  title,
                  style: context.textTheme().bodyLarge?.copyWith(
                        color: isSelected ? ProjectColors.darkAvocado : ProjectColors.grey600,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
