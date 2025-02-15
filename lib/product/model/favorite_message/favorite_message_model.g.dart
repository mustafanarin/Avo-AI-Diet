// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_message_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteMessageModelAdapter extends TypeAdapter<FavoriteMessageModel> {
  @override
  final int typeId = 2;

  @override
  FavoriteMessageModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteMessageModel(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteMessageModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.content)
      ..writeByte(1)
      ..write(obj.savedAt)
      ..writeByte(2)
      ..write(obj.messageId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteMessageModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
