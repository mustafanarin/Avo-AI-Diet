// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AiResponseAdapter extends TypeAdapter<AiResponse> {
  @override
  final int typeId = 0;

  @override
  AiResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AiResponse(
      dietPlan: fields[0] as String,
      createdAt: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AiResponse obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.dietPlan)
      ..writeByte(1)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AiResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
