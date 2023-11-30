import 'dart:convert';
import 'package:http/http.dart' as http;

import 'service.dart';

// This file literally contains two definitions
// const String apiEndpoint = "";
// const String apiToken = "";
import 'api_settings.dart';

Future<Service?> getServiceDetails(String rid) async {
  final response = await http.get(
    Uri.parse("$apiEndpoint/details?rid=$rid&token=$apiToken"),
  );

  if (response.statusCode == 200) {
    return Service.fromJson(jsonDecode(response.body)['services']);
  }

  return null;
}

Future<List<Service>?> getDepartures(String crs) async {
  final response = await http.get(
    Uri.parse("$apiEndpoint/departures?crs=$crs&token=$apiToken"),
  );

  if (response.statusCode == 200) {
    List<Service> services = [];

    for (dynamic service in jsonDecode(response.body)['services']) {
      services.add(Service.fromJson(service));
    }

    return services;
  }

  return null;
}

Future<List<Service>?> getArrivals(String crs) async {
  final response = await http.get(
    Uri.parse("$apiEndpoint/arrivals?crs=$crs&token=$apiToken"),
  );

  if (response.statusCode == 200) {
    List<Service> services = [];

    for (dynamic service in jsonDecode(response.body)['services']) {
      services.add(Service.fromJson(service));
    }

    return services;
  }

  return null;
}