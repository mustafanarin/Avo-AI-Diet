part of '../favorite_view.dart';

class _CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const _CustomAppbar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Text(
            ProjectStrings.myFavorites,
            style: context.textTheme().titleLarge,
          ),
          if (context.select((FavoritesCubit cubit) => cubit.state.favorites?.isNotEmpty ?? false)) ...[
            const SizedBox(width: 8),
            Image.asset(
              PngName.noFavoriteAvo.path,
              height: 34.h,
            ),
          ],
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
