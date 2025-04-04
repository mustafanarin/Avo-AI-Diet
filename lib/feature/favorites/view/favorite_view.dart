import 'package:avo_ai_diet/feature/favorites/cubit/favorites_cubit.dart';
import 'package:avo_ai_diet/feature/favorites/state/favorites_state.dart';
import 'package:avo_ai_diet/product/constants/project_colors.dart';
import 'package:avo_ai_diet/product/constants/project_strings.dart';
import 'package:avo_ai_diet/product/utility/extensions/text_theme_extension.dart';
import 'package:avo_ai_diet/product/widgets/project_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavoriteView extends StatefulWidget {
  const FavoriteView({super.key});

  @override
  State<FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> {
  void _showFullText(BuildContext context, String text) {
    // TODOscroll shadow
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: ProjectColors.backgroundCream,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                ProjectStrings.details,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 16.h),
              Container(
                constraints: BoxConstraints(maxHeight: 400.h),
                child: SingleChildScrollView(
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              SizedBox(
                width: 100.h,
                height: 50.w,
                child: ProjectButton(
                  text: ProjectStrings.close,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ProjectStrings.myFavorites,
          style: context.textTheme().titleLarge,
        ),
      ),
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
              return const Center(
                child: Text(ProjectStrings.noFavorite),
              );
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
                    final favoriteMessage = state.favorites![index];
                    return InkWell(
                      onTap: () => _showFullText(context, favoriteMessage.content),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              ProjectColors.lightAvocado.withOpacity(0.9),
                              ProjectColors.accentCoral.withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: ProjectColors.darkAvocado.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  BlocBuilder<FavoritesCubit, FavoritesState>(
                                    builder: (context, state) {
                                      return SizedBox(
                                        height: 20.h,
                                        width: 20.w,
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
                                            context.read<FavoritesCubit>().toogleFavorite(favoriteMessage);
                                          },
                                          icon: Icon(
                                            Icons.favorite,
                                            color: ProjectColors.red,
                                            size: 24.w,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  Text(
                                    favoriteMessage.savedAt,
                                    style: context.textTheme().bodySmall,
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              Expanded(
                                child: Text(
                                  favoriteMessage.content,
                                  style: context.textTheme().bodyMedium?.copyWith(
                                        color: ProjectColors.white,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 8,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
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
