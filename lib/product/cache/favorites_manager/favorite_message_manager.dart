import 'package:avo_ai_diet/product/model/favorite_message/favorite_message_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

@injectable
class FavoriteMessageManager {
  LazyBox<FavoriteMessageModel>? _box;

  Future<LazyBox<FavoriteMessageModel>?> _getBox() async {
    if (_box != null) return _box;
    _box = await Hive.openLazyBox<FavoriteMessageModel>('favoriteMessages');
    return _box!;
  }

  Future<void> toggleFavorite(FavoriteMessageModel model) async {
    final box = await _getBox();

    if (box!.containsKey(model.savedAt)) {
      await box.delete(model.savedAt);
    } else {
      await box.put(model.savedAt, model);
    }
  }

  Future<List<FavoriteMessageModel>?> getFavorites() async {
    final box = await _getBox();
    if (box == null) return null;

    final favorites = <FavoriteMessageModel>[];

    for (final key in box.keys) {
      final value = await box.get(key);
      if (value != null) {
        favorites.add(value);
      }
    }
    return favorites;
  }
}
