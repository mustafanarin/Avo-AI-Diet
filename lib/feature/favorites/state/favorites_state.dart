// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:avo_ai_diet/product/model/favorite_message/favorite_message_model.dart';

class FavoritesState {
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
