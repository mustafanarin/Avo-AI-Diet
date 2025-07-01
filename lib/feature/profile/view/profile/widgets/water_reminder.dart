part of '../profile_view.dart';


class _SwitchItemWidget extends StatelessWidget {
  const _SwitchItemWidget({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
  });
  final String title;
  final String subtitle;
  final IconData icon;
  final bool value;
  final void Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ProjectColors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: ProjectColors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              color: ProjectColors.apple,
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Icon(
              icon,
              color: ProjectColors.white,
              size: 30.w,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: ProjectColors.laurel,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style:
                      context.textTheme().bodySmall?.copyWith(color: ProjectColors.earthBrown.withValues(alpha: 0.8)),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: ProjectColors.mayGreen,
            activeTrackColor: ProjectColors.dolarBill,
          ),
        ],
      ),
    );
  }
}

class _WaterReminderSwitchItem extends StatelessWidget {
  const _WaterReminderSwitchItem();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WaterReminderCubit, WaterReminderState>(
      builder: (context, state) {
        return _SwitchItemWidget(
          title: ProjectStrings.waterReminder,
          subtitle: ProjectStrings.reminderSupTitle,
          icon: Icons.water_drop_outlined,
          value: state.isEnabled,
          onChanged: (value) {
            context.read<WaterReminderCubit>().toggleWaterReminder(value);
          },
        );
      },
    );
  }
}
