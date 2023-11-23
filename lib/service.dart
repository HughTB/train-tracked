import 'stopping_point.dart';

class Service {
  int rid;
  StoppingPoint origin;
  StoppingPoint destination;
  List<StoppingPoint> stoppingPoints;
  int? numCoaches;
  String? thisSta;
  String? thisEta;
  String? thisStd;
  String? thisEtd;
  String? thisPlatform;

  Service(this.rid, this.origin, this.destination, this.stoppingPoints, this.thisSta, this.thisEta, this.thisStd, this.thisEtd, this.thisPlatform, this.numCoaches);
}