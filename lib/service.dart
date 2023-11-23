import 'package:hive/hive.dart';

import 'stopping_point.dart';

part 'service.g.dart';

@HiveType(typeId: 2)
class Service {
  @HiveField(0)
  int rid;
  @HiveField(1)
  StoppingPoint origin;
  @HiveField(2)
  StoppingPoint destination;
  @HiveField(3)
  List<StoppingPoint> stoppingPoints;
  @HiveField(4)
  int? numCoaches;
  @HiveField(5)
  String? thisSta;
  @HiveField(6)
  String? thisEta;
  @HiveField(7)
  String? thisStd;
  @HiveField(8)
  String? thisEtd;
  @HiveField(9)
  String? thisPlatform;

  Service(this.rid, this.origin, this.destination, this.stoppingPoints, this.thisSta, this.thisEta, this.thisStd, this.thisEtd, this.thisPlatform, this.numCoaches);
}