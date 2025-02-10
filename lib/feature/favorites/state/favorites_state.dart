// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:avo_ai_diet/product/model/favorite_message/favorite_message_model.dart';

class FavoritesState {
  FavoritesState({this.favorites, this.savedAt, this.isLoading = false});

  final List<FavoriteMessageModel>? favorites;
  final DateTime? savedAt;
  final bool isLoading;

  FavoritesState copyWith({
    List<FavoriteMessageModel>? favorites,
    DateTime? savedAt,
    bool? isLoading,
  }) {
    return FavoritesState(
      favorites: favorites ?? this.favorites,
      savedAt: savedAt ?? this.savedAt,
      isLoading: isLoading ?? false,
    );
  }
}
