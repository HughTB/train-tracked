import 'package:hive/hive.dart';

part 'station.g.dart';

@HiveType(typeId: 0)
class Station {
  @HiveField(0)
  final String? stationName;
  @HiveField(1)
  final double? lat;
  @HiveField(2)
  final double? long;
  @HiveField(3)
  final String? crs;

  const Station(this.stationName, this.lat, this.long, this.crs);
}