import 'package:hive/hive.dart';

import 'stopping_point.dart';

part 'service.g.dart';

@HiveType(typeId: 2)
class Service {
  @HiveField(0)
  late String rid;
  @HiveField(1)
  late String trainId;
  @HiveField(2)
  late String operator;
  @HiveField(3)
  late String operatorCode;
  @HiveField(4)
  String? sta;
  @HiveField(5)
  String? ata;
  @HiveField(6)
  bool? ataForecast;
  @HiveField(7)
  String? std;
  @HiveField(8)
  String? atd;
  @HiveField(9)
  bool? atdForecast;
  @HiveField(10)
  String? platform;
  @HiveField(11)
  late List<String> origin = [];
  @HiveField(12)
  late List<String> destination = [];
  @HiveField(13)
  late List<StoppingPoint> stoppingPoints = [];
  @HiveField(14)
  bool? cancelledHere;

  Service();

  Service.fromJson(Map<String, dynamic> json) {
    rid = json['rid'];
    trainId = json['trainId'];
    operator = json['operator'];
    operatorCode = json['operatorCode'];
    sta = json['sta'];
    ata = json['ata'];
    ataForecast = json['ataForecast'];
    std = json['std'];
    atd = json['atd'];
    atdForecast = json['atdForecast'];
    platform = json['platform'];
    for (dynamic val in json['origin']) {
      origin.add(val.toString());
    }
    for (dynamic val in json['destination']) {
      destination.add(val.toString());
    }

    for (dynamic stoppingPoint in json['stoppingPoints']) {
      stoppingPoints.add(StoppingPoint.fromJson(stoppingPoint));
    }

    cancelledHere = json['cancelled'];
  }
}