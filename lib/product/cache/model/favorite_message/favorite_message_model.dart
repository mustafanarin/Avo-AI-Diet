import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'favorite_message_model.g.dart';

// TODOequtable
@HiveType(typeId: 2)
final class FavoriteMessageModel extends Equatable {
  const FavoriteMessageModel(this.content, this.savedAt, this.messageId);

  @HiveField(0)
  final String content;

  @HiveField(1)
  final String savedAt;

  @HiveField(2)
  final String messageId;

  @override
  List<Object?> get props => [messageId, content, savedAt];
}
