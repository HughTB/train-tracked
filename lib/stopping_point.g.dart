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
    return StoppingPoint()
      ..platform = fields[0] as String?
      ..sta = fields[1] as String?
      ..ata = fields[2] as String?
      ..ataForecast = fields[3] as bool?
      ..std = fields[4] as String?
      ..atd = fields[5] as String?
      ..atdForecast = fields[6] as bool?
      ..crs = fields[7] as String?
      ..attachRid = fields[8] as String?;
  }

  @override
  void write(BinaryWriter writer, StoppingPoint obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.platform)
      ..writeByte(1)
      ..write(obj.sta)
      ..writeByte(2)
      ..write(obj.ata)
      ..writeByte(3)
      ..write(obj.ataForecast)
      ..writeByte(4)
      ..write(obj.std)
      ..writeByte(5)
      ..write(obj.atd)
      ..writeByte(6)
      ..write(obj.atdForecast)
      ..writeByte(7)
      ..write(obj.crs)
      ..writeByte(8)
      ..write(obj.attachRid);
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
