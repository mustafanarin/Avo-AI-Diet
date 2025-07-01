part of '../favorite_view.dart';

class _FavoriteCard extends StatelessWidget {
  const _FavoriteCard({required this.favoriteMessage});

  final FavoriteMessageModel favoriteMessage;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showFullText(context, favoriteMessage.content),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ProjectColors.lightAvocado.withValues(alpha: 0.9),
              ProjectColors.accentCoral.withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
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
                  // Favorite icon & date
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
                              icon: Icon(Icons.favorite, color: ProjectColors.red, size: 24.w),
                            ),
                          );
                        },
                      ),
                      Text(favoriteMessage.savedAt, style: context.textTheme().bodySmall),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Expanded(
                    child: Markdown(
                      data: favoriteMessage.content,
                      shrinkWrap: true,
                      styleSheet: MarkdownStyleSheet(
                        p: context.textTheme().bodyMedium?.copyWith(color: ProjectColors.white),
                        strong: context.textTheme().bodyMedium?.copyWith(
                          color: ProjectColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        em: context.textTheme().bodyMedium?.copyWith(
                          color: ProjectColors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      softLineBreak: true,
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
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      ProjectColors.accentCoral.withValues(alpha: 0.2),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                padding: const EdgeInsets.only(bottom: 12),
                alignment: Alignment.bottomCenter,
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
  }
}
