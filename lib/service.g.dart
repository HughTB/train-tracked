// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServiceAdapter extends TypeAdapter<Service> {
  @override
  final int typeId = 2;

  @override
  Service read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Service(
      fields[0] as String,
      fields[1] as StoppingPoint,
      fields[2] as StoppingPoint,
      (fields[3] as List).cast<StoppingPoint>(),
      fields[5] as String?,
      fields[6] as String?,
      fields[7] as String?,
      fields[8] as String?,
      fields[9] as String?,
      fields[4] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Service obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.rid)
      ..writeByte(1)
      ..write(obj.origin)
      ..writeByte(2)
      ..write(obj.destination)
      ..writeByte(3)
      ..write(obj.stoppingPoints)
      ..writeByte(4)
      ..write(obj.numCoaches)
      ..writeByte(5)
      ..write(obj.thisSta)
      ..writeByte(6)
      ..write(obj.thisEta)
      ..writeByte(7)
      ..write(obj.thisStd)
      ..writeByte(8)
      ..write(obj.thisEtd)
      ..writeByte(9)
      ..write(obj.thisPlatform);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
