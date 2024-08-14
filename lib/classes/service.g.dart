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
    return Service()
      ..rid = fields[0] as String
      ..trainId = fields[1] as String
      ..operator = fields[2] as String
      ..operatorCode = fields[3] as String
      ..sta = fields[4] as String?
      ..ata = fields[5] as String?
      ..ataForecast = fields[6] as bool?
      ..std = fields[7] as String?
      ..atd = fields[8] as String?
      ..atdForecast = fields[9] as bool?
      ..platform = fields[10] as String?
      ..origin = (fields[11] as List).cast<String>()
      ..destination = (fields[12] as List).cast<String>()
      ..stoppingPoints = (fields[13] as List).cast<StoppingPoint>()
      ..cancelledHere = fields[14] as bool?
      ..getUpdates = fields[15] as bool?
      ..delayReason = fields[16] as String?
      ..cancelReason = fields[17] as String?
      ..numCoaches = fields[18] as int?
      ..loadingPercentage = fields[19] as int?;
  }

  @override
  void write(BinaryWriter writer, Service obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.rid)
      ..writeByte(1)
      ..write(obj.trainId)
      ..writeByte(2)
      ..write(obj.operator)
      ..writeByte(3)
      ..write(obj.operatorCode)
      ..writeByte(4)
      ..write(obj.sta)
      ..writeByte(5)
      ..write(obj.ata)
      ..writeByte(6)
      ..write(obj.ataForecast)
      ..writeByte(7)
      ..write(obj.std)
      ..writeByte(8)
      ..write(obj.atd)
      ..writeByte(9)
      ..write(obj.atdForecast)
      ..writeByte(10)
      ..write(obj.platform)
      ..writeByte(11)
      ..write(obj.origin)
      ..writeByte(12)
      ..write(obj.destination)
      ..writeByte(13)
      ..write(obj.stoppingPoints)
      ..writeByte(14)
      ..write(obj.cancelledHere)
      ..writeByte(15)
      ..write(obj.getUpdates)
      ..writeByte(16)
      ..write(obj.delayReason)
      ..writeByte(17)
      ..write(obj.cancelReason)
      ..writeByte(18)
      ..write(obj.numCoaches)
      ..writeByte(19)
      ..write(obj.loadingPercentage);
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
