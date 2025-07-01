part of '../home_view.dart';

class _CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _CustomAppBar({required this.name});

  final String? name;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name != null ? '${ProjectStrings.hello} $name' : ProjectStrings.hello,
            style: context.textTheme().titleMedium,
          ),
          Hero(
            tag: HeroLottie.avoLottie.value,
            child: Lottie.asset(
              JsonName.avoWalk.path,
              height: 70.h,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
