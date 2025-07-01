part of '../chat_view.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({
    required this.text,
    required this.isMe,
    super.key,
    this.isLoading = false,
  });

  final String text;
  final bool isMe;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final favoritesCubit = context.read<FavoritesCubit>();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe)
            Container(
              margin: const EdgeInsets.only(right: 16),
              child: const CircleAvatar(
                backgroundColor: ProjectColors.darkGreen,
                child: Icon(
                  Icons.eco,
                  color: ProjectColors.white,
                ),
              ),
            ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isMe ? ProjectColors.darkGreen : ProjectColors.white,
                borderRadius: AppRadius.circularSmall(),
                boxShadow: [
                  BoxShadow(
                    color: ProjectColors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isLoading)
                    Lottie.asset(
                      JsonName.writing.path,
                      height: 35.h,
                      width: 35.w,
                    )
                  else
                    MarkdownBody(
                      data: text,
                      styleSheet: MarkdownStyleSheet(
                        p: TextStyle(
                          color: isMe ? ProjectColors.white : ProjectColors.black,
                        ),
                        strong: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isMe ? ProjectColors.white : ProjectColors.black,
                        ),
                        em: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: isMe ? ProjectColors.white : ProjectColors.black,
                        ),
                        listBullet: TextStyle(
                          color: isMe ? ProjectColors.white : ProjectColors.black,
                        ),
                      ),
                      selectable: true,
                    ),
                  if (!isLoading && !isMe) ...[
                    const SizedBox(height: 4),
                    BlocBuilder<FavoritesCubit, FavoritesState>(
                      builder: (context, state) {
                        final messageId = text.hashCode.toString();
                        final isFavorited = state.favorites?.any(
                              (favorite) => favorite.messageId == messageId,
                            ) ??
                            false;

                        return SizedBox(
                          height: 20,
                          width: 20,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              final now = DateTime.now();
                              final model = FavoriteMessageModel(
                                text,
                                DateFormat('d MMMM yyyy', 'tr_TR').format(now),
                                messageId,
                              );
                              favoritesCubit.toogleFavorite(model);
                            },
                            icon: Icon(
                              isFavorited ? Icons.favorite : Icons.favorite_border,
                              color: isFavorited ? ProjectColors.red : ProjectColors.grey,
                              size: 20,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}