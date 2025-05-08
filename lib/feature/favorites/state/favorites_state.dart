import 'package:avo_ai_diet/product/cache/model/favorite_message/favorite_message_model.dart';

final class FavoritesState {
  FavoritesState({this.favorites, this.messageId, this.savedAt, this.isLoading = false});

  final List<FavoriteMessageModel>? favorites;
  final String? savedAt;
  final String? messageId;
  final bool isLoading;

  FavoritesState copyWith({
    List<FavoriteMessageModel>? favorites,
    String? savedAt,
    String? messageId,
    bool? isLoading,
  }) {
    return FavoritesState(
      favorites: favorites ?? this.favorites,
      savedAt: savedAt ?? this.savedAt,
      messageId: messageId ?? this.messageId,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
