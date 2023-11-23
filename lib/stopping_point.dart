import 'station.dart';

class StoppingPoint {
  String? platform;
  DateTime? sta;
  DateTime? eta;
  DateTime? std;
  DateTime? etd;
  Station? station;
  bool forecast;

  StoppingPoint(this.platform, this.sta, this.eta, this.std, this.etd, this.station, this.forecast);
}