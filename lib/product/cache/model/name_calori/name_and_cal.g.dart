// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'name_and_cal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NameAndCalModelAdapter extends TypeAdapter<NameAndCalModel> {
  @override
  final int typeId = 1;

  @override
  NameAndCalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NameAndCalModel(
      userName: fields[0] as String,
      targetCal: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, NameAndCalModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.userName)
      ..writeByte(1)
      ..write(obj.targetCal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NameAndCalModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
