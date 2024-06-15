class Disruption {
  String? id;
  String? category;
  String? severity;
  bool? suppressed;
  String? message;
  String? description;

  Disruption.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
    severity = json['severity'];
    suppressed = json['suppressed'];
    message = json['message'];
    description = json['description'];
  }
}