import 'package:avo_ai_diet/feature/favorites/cubit/favorites_cubit.dart';
import 'package:avo_ai_diet/feature/favorites/state/favorites_state.dart';
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

final class FavoriteView extends StatefulWidget {
  const FavoriteView({super.key});

  @override
  State<FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                              ProjectColors.lightAvocado.withValues(alpha: 0.9),
                              ProjectColors.accentCoral.withValues(alpha: 0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: ProjectColors.darkAvocado.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(12.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // favorite button and date
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
                                  // Favorite text
                                  Expanded(
                                    child: Markdown(
                                      data: favoriteMessage.content,
                                      styleSheet: MarkdownStyleSheet(
                                        p: context.textTheme().bodyMedium?.copyWith(
                                              color: ProjectColors.white,
                                            ),
                                        pPadding: EdgeInsets.zero,
                                        blockSpacing: 4,
                                        strong: context.textTheme().bodyMedium?.copyWith(
                                              color: ProjectColors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                        em: context.textTheme().bodyMedium?.copyWith(
                                              color: ProjectColors.white,
                                              fontStyle: FontStyle.italic,
                                            ),
                                      ),
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      softLineBreak: true,
                                      padding: EdgeInsets.zero,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                  ),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      ProjectColors.accentCoral.withValues(alpha: 0.2),
                                    ],
                                  ),
                                ),
                                alignment: Alignment.bottomCenter,
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Container(
                                  width: 40,
                                  height: 3,
                                  decoration: BoxDecoration(
                                    color: ProjectColors.white,
                                    borderRadius: BorderRadius.circular(1.5),
                                  ),
                                ),
                              ),
                            ),
                          ],
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

void _showFullText(BuildContext context, String text) {
  showDialog<void>(
    context: context,
    builder: (dialogContext) => HookBuilder(
      builder: (hookContext) {
        final showTopShadow = useState(false);
        final textTheme = hookContext.textTheme();

        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Container(
            constraints: BoxConstraints(maxHeight: 500.h),
            decoration: BoxDecoration(
              color: ProjectColors.backgroundCream,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: ProjectColors.darkAvocado.withValues(alpha: 0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        ProjectColors.lightAvocado.withValues(alpha: 0.9),
                        ProjectColors.accentCoral.withValues(alpha: 0.8),
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.menu_book_rounded,
                        color: ProjectColors.white,
                        size: 24.r,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        ProjectStrings.details,
                        style: textTheme.titleMedium?.copyWith(
                          color: ProjectColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        icon: Icon(
                          Icons.close_rounded,
                          color: ProjectColors.white,
                          size: 24.r,
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Stack(
                    children: [
                      NotificationListener<ScrollNotification>(
                        onNotification: (scrollNotification) {
                          final shouldShowShadow = scrollNotification.metrics.pixels > 10;
                          if (showTopShadow.value != shouldShowShadow) {
                            showTopShadow.value = shouldShowShadow;
                          }
                          return true;
                        },
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          child: SingleChildScrollView(
                            physics: const ClampingScrollPhysics(),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 20.h),
                              child: Markdown(
                                data: text,
                                styleSheet: MarkdownStyleSheet(
                                  p: textTheme.bodyMedium?.copyWith(
                                    fontSize: 16.sp,
                                    height: 1.5,
                                  ),
                                  strong: textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                    height: 1.5,
                                  ),
                                  em: textTheme.bodyMedium?.copyWith(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 16.sp,
                                    height: 1.5,
                                  ),
                                  listBullet: textTheme.bodyMedium?.copyWith(
                                    color: ProjectColors.forestGreen,
                                    fontSize: 16.sp,
                                  ),
                                  h1: textTheme.titleLarge?.copyWith(
                                    color: ProjectColors.darkAvocado,
                                    fontSize: 20.sp,
                                  ),
                                  h2: textTheme.titleMedium?.copyWith(
                                    color: ProjectColors.forestGreen,
                                    fontSize: 18.sp,
                                  ),
                                ),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: AnimatedOpacity(
                          opacity: showTopShadow.value ? 1.0 : 0.0,
                          duration: AppDurations.smallMilliseconds(),
                          child: Container(
                            height: 24,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  ProjectColors.black.withValues(alpha: 0.15),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
