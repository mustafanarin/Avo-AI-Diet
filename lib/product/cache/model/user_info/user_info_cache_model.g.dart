// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info_cache_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserInfoCacheModelAdapter extends TypeAdapter<UserInfoCacheModel> {
  @override
  final int typeId = 4;

  @override
  UserInfoCacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserInfoCacheModel(
      gender: fields[0] as String,
      age: fields[1] as String,
      height: fields[2] as String,
      weight: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserInfoCacheModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.gender)
      ..writeByte(1)
      ..write(obj.age)
      ..writeByte(2)
      ..write(obj.height)
      ..writeByte(3)
      ..write(obj.weight);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserInfoCacheModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
