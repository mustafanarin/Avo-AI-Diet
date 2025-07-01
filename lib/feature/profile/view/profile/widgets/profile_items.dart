part of '../profile_view.dart';

class _ProfileItems extends StatelessWidget {
  const _ProfileItems({
    required this.onNameEditTap,
    required this.onUserInfoEditTap,
    required this.onRegionalBodyTap,
  });
  final VoidCallback onNameEditTap;
  final VoidCallback onUserInfoEditTap;
  final VoidCallback onRegionalBodyTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ProfileItemWidget(
          title: ProjectStrings.changeName,
          subtitle: ProjectStrings.changeNameSupTitle,
          icon: Icons.person_outline,
          onTap: onNameEditTap,
        ),
        SizedBox(height: 16.h),
        _ProfileItemWidget(
          title: ProjectStrings.bodyInformation,
          subtitle: ProjectStrings.bodyInformationSupTitle,
          icon: Icons.accessibility_new_outlined,
          onTap: onUserInfoEditTap,
        ),
        SizedBox(height: 16.h),
        _ProfileItemWidget(
          title: ProjectStrings.regionalFatBurning,
          subtitle: ProjectStrings.fatBurningSupTitle,
          icon: Icons.local_fire_department_outlined,
          onTap: onRegionalBodyTap,
        ),
        SizedBox(height: 16.h),
        const _WaterReminderSwitchItem(),
        SizedBox(height: 30.h),
      ],
    );
  }
}


class _ProfileItemWidget extends StatelessWidget {
  const _ProfileItemWidget({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(20.r),
        onTap: onTap,
        splashColor: ProjectColors.apple.withValues(alpha: 0.2),
        highlightColor: ProjectColors.apple.withValues(alpha: 0.1),
        child: Padding(
          padding: EdgeInsets.all(16.w),
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
                  color: Colors.white,
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
                      style: context.textTheme().titleMedium?.copyWith(color: ProjectColors.laurel),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: context
                          .textTheme()
                          .bodySmall
                          ?.copyWith(color: ProjectColors.earthBrown.withValues(alpha: 0.8)),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 26.w,
                color: ProjectColors.laurel,
              ),
            ],
          ),
        ),
      ),
    );
  }
}