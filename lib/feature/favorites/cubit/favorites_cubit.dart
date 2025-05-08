import 'package:avo_ai_diet/feature/favorites/state/favorites_state.dart';
import 'package:avo_ai_diet/product/cache/manager/favorites/favorite_message_manager.dart';
import 'package:avo_ai_diet/product/cache/model/favorite_message/favorite_message_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
final class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit(this._manager) : super(FavoritesState()) {
    _initFavorites();
  }

  final IFavoriteMessageManager _manager;

  Future<void> _initFavorites() async {
    await getFavorites();
  }

  Future<void> getFavorites() async {
    emit(state.copyWith(isLoading: true));
    try {
      final favorites = await _manager.getFavorites();
      emit(state.copyWith(favorites: favorites));
    } on Exception catch (e) {
      throw Exception(e.toString());
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> toogleFavorite(FavoriteMessageModel model) async {
    emit(state.copyWith(isLoading: true));
    try {
      await _manager.toggleFavorite(model);
      await getFavorites();
    } on Exception catch (e) {
      throw Exception(e.toString());
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }
}
