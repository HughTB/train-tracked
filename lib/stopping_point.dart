import 'package:hive/hive.dart';

import 'station.dart';

part 'stopping_point.g.dart';

@HiveType(typeId: 1)
class StoppingPoint {
  @HiveField(0)
  String? platform;
  @HiveField(1)
  DateTime? sta;
  @HiveField(2)
  DateTime? eta;
  @HiveField(3)
  DateTime? std;
  @HiveField(4)
  DateTime? etd;
  @HiveField(5)
  Station? station;
  @HiveField(6)
  bool forecast;

  StoppingPoint(this.platform, this.sta, this.eta, this.std, this.etd, this.station, this.forecast);
}