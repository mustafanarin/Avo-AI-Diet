part of '../user_info_view.dart';

class _CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const _CustomAppbar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        ProjectStrings.userInfoAppbar,
      ),
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      leading: const BackButton(
        color: ProjectColors.earthBrown,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
