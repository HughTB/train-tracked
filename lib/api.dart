import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'service.dart';

// This file literally contains two definitions
// const String apiEndpoint = "";
// const String apiToken = "";
import 'api_settings.dart';

Future<Service?> getServiceDetails(String rid, ScaffoldMessengerState messenger) async {
  try {
    final response = await http.get(
      Uri.parse("$apiEndpoint/details?rid=$rid&token=$apiToken"),
    );

    if (response.statusCode == 200) {
      return Service.fromJson(jsonDecode(response.body)['services']);
    } else {
      messenger.showSnackBar(
          SnackBar(
            content: Text("${response.statusCode}: ${response.reasonPhrase}"),
          )
      );
    }
  } on Exception catch (e) {
    messenger.showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString().replaceAll(apiToken, '{apiToken}')}"),
        )
    );
  }

  return null;
}

Future<List<Service>?> getDepartures(String crs, ScaffoldMessengerState messenger) async {
  try {
    final response = await http.get(
      Uri.parse("$apiEndpoint/departures?crs=$crs&token=$apiToken"),
    );

    if (response.statusCode == 200) {
      List<Service> services = [];

      for (dynamic service in jsonDecode(response.body)['services']) {
        services.add(Service.fromJson(service));
      }

      return services;
    } else {
      messenger.showSnackBar(
          SnackBar(
            content: Text("${response.statusCode}: ${response.reasonPhrase}"),
          )
      );
    }
  } on Exception catch (e) {
    messenger.showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString().replaceAll(apiToken, '{apiToken}')}"),
        )
    );
  }

  return null;
}

Future<List<Service>?> getArrivals(String crs, ScaffoldMessengerState messenger) async {
  try {
    final response = await http.get(
      Uri.parse("$apiEndpoint/arrivals?crs=$crs&token=$apiToken"),
    );

    if (response.statusCode == 200) {
      List<Service> services = [];

      for (dynamic service in jsonDecode(response.body)['services']) {
        services.add(Service.fromJson(service));
      }

      return services;
    } else {
      messenger.showSnackBar(
          SnackBar(
            content: Text("${response.statusCode}: ${response.reasonPhrase}"),
          )
      );
    }
  } on Exception catch (e) {
    messenger.showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString().replaceAll(apiToken, '{apiToken}')}"),
        )
    );
  }

  return null;
}