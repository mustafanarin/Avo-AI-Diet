// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_calorie_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyCalorieModelAdapter extends TypeAdapter<DailyCalorieModel> {
  @override
  final int typeId = 3;

  @override
  DailyCalorieModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyCalorieModel(
      lastResetDate: fields[1] as String,
      currentCalories: fields[0] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DailyCalorieModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.currentCalories)
      ..writeByte(1)
      ..write(obj.lastResetDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyCalorieModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
