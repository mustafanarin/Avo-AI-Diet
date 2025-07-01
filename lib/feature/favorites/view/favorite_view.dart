import 'package:avo_ai_diet/feature/favorites/cubit/favorites_cubit.dart';
import 'package:avo_ai_diet/feature/favorites/state/favorites_state.dart';
import 'package:avo_ai_diet/product/cache/model/favorite_message/favorite_message_model.dart';
import 'package:avo_ai_diet/product/constants/enum/general/png_name.dart';
import 'package:avo_ai_diet/product/constants/enum/project_settings/app_durations.dart';
import 'package:avo_ai_diet/product/constants/project_colors.dart';
import 'package:avo_ai_diet/product/constants/project_strings.dart';
import 'package:avo_ai_diet/product/utility/extensions/png_extension.dart';
import 'package:avo_ai_diet/product/utility/extensions/text_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part './widgets/app_bar.dart';
part './widgets/favorite_card.dart';
part './widgets/no_favorite.dart';
part './widgets/show_full_text.dart';

final class FavoriteView extends StatefulWidget {
  const FavoriteView({super.key});

  @override
  State<FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _CustomAppbar(),
      body: Padding(
        padding: EdgeInsets.all(12.w),
        child: BlocBuilder<FavoritesCubit, FavoritesState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state.favorites == null || state.favorites!.isEmpty) {
              return const _NoFavorite();
            }
            return LayoutBuilder(
              builder: (context, constraints) {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: constraints.maxWidth / 2,
                    mainAxisExtent: 250.h,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 12.h,
                  ),
                  itemCount: state.favorites!.length,
                  itemBuilder: (context, index) {
                    return _FavoriteCard(favoriteMessage: state.favorites![index]);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
