// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'station.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StationAdapter extends TypeAdapter<Station> {
  @override
  final int typeId = 0;

  @override
  Station read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Station(
      fields[0] as String?,
      fields[1] as double?,
      fields[2] as double?,
      fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Station obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.stationName)
      ..writeByte(1)
      ..write(obj.lat)
      ..writeByte(2)
      ..write(obj.long)
      ..writeByte(3)
      ..write(obj.crs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
