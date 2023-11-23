import 'package:hive/hive.dart';

part 'station.g.dart';

@HiveType(typeId: 0)
class Station {
  @HiveField(0)
  String? stationName;
  @HiveField(1)
  double? lat;
  @HiveField(2)
  double? long;
  @HiveField(3)
  String? crs;

  Station(this.stationName, this.lat, this.long, this.crs);
}