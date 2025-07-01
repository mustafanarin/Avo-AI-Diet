part of '../chat_view.dart';

class _CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const _CustomAppbar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 10,
      title: Row(
        children: [
          const Icon(Icons.eco, color: ProjectColors.darkGreen),
          const SizedBox(width: 8),
          Text(
            ProjectStrings.askToAvo,
            style: context.textTheme().titleLarge?.copyWith(
                  color: ProjectColors.darkGreen,
                ),
          ),
        ],
      ),
      elevation: 1,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
