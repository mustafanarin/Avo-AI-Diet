// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_reminder_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WaterReminderModelAdapter extends TypeAdapter<WaterReminderModel> {
  @override
  final int typeId = 5;

  @override
  WaterReminderModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WaterReminderModel(
      waterReminderEnabled: fields[0] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, WaterReminderModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.waterReminderEnabled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WaterReminderModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
