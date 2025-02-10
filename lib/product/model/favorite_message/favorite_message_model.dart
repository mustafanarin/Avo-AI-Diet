import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'favorite_message_model.g.dart';
// TODO equtable
@HiveType(typeId: 2)
class FavoriteMessageModel extends Equatable {
  const FavoriteMessageModel(this.content, this.savedAt);

  @HiveField(0)
  final String content;

  @HiveField(1)
  final DateTime savedAt;

  @override
  List<Object?> get props => [content, savedAt];
}
