// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stopping_point.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StoppingPointAdapter extends TypeAdapter<StoppingPoint> {
  @override
  final int typeId = 1;

  @override
  StoppingPoint read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StoppingPoint(
      fields[0] as String?,
      fields[1] as DateTime?,
      fields[2] as DateTime?,
      fields[3] as DateTime?,
      fields[4] as DateTime?,
      fields[5] as Station?,
      fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, StoppingPoint obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.platform)
      ..writeByte(1)
      ..write(obj.sta)
      ..writeByte(2)
      ..write(obj.eta)
      ..writeByte(3)
      ..write(obj.std)
      ..writeByte(4)
      ..write(obj.etd)
      ..writeByte(5)
      ..write(obj.station)
      ..writeByte(6)
      ..write(obj.forecast);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoppingPointAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
