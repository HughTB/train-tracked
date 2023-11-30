import 'package:hive/hive.dart';

import 'station.dart';

part 'stopping_point.g.dart';

@HiveType(typeId: 1)
class StoppingPoint {
  @HiveField(0)
  String? platform;
  @HiveField(1)
  String? sta;
  @HiveField(2)
  String? ata;
  @HiveField(3)
  bool? ataForecast;
  @HiveField(4)
  String? std;
  @HiveField(5)
  String? atd;
  @HiveField(6)
  bool? atdForecast;
  @HiveField(7)
  String? crs;
  @HiveField(8)
  String? attachRid;

  StoppingPoint();

  StoppingPoint.fromJson(Map<String, dynamic> json) {
    platform = json['platform'];
    sta = json['sta'];
    ata = json['ata'];
    ataForecast = json['ataForecast'];
    std = json['std'];
    atd = json['atd'];
    atdForecast = json['atdForecast'];
    crs = json['crs'];
    attachRid = json['attachRid'];
  }
}