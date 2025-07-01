part of '../favorite_view.dart';

class _NoFavorite extends StatelessWidget {
  const _NoFavorite();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            PngName.noFavoriteAvo.path,
            height: 120.h,
          ),
          const Text(ProjectStrings.noFavorite),
        ],
      ),
    );
  }
}