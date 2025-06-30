import 'package:avo_ai_diet/product/cache/model/favorite_message/favorite_message_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class IFavoriteMessageManager {
  Future<void> toggleFavorite(FavoriteMessageModel model);
  Future<List<FavoriteMessageModel>?> getFavorites();
}

final class FavoriteMessageManager implements IFavoriteMessageManager {
  LazyBox<FavoriteMessageModel>? _box;
  static const String _favMessages = 'favoriteMessages';

  Future<LazyBox<FavoriteMessageModel>?> _getBox() async {
    _box ??= await Hive.openLazyBox<FavoriteMessageModel>(_favMessages);
    return _box!;
  }

  @override
  Future<void> toggleFavorite(FavoriteMessageModel model) async {
    final box = await _getBox();

    if (box!.containsKey(model.messageId)) {
      await box.delete(model.messageId);
    } else {
      await box.put(model.messageId, model);
    }
  }

  @override
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
