import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../classes/service.dart';
import '../classes/disruption.dart';

// This file literally contains two definitions
// const String apiEndpoint = "";
// const String apiToken = "";
import 'api_settings.dart';

Future<Service?> getServiceDetails(String rid, ScaffoldMessengerState? messenger) async {
  try {
    final response = await http.get(
      Uri.parse("$apiEndpoint/details?rid=$rid"),
      headers: {
        "x-api-key": apiToken,
      }
    );

    if (response.statusCode == 200) {
      return Service.fromJson(jsonDecode(response.body)['services']);
    } else {
      messenger?.showSnackBar(
          SnackBar(
            content: Text("${response.statusCode}: ${response.reasonPhrase}"),
          )
      );
    }
  } on SocketException catch (e) {
    log(e.toString());
    messenger?.showSnackBar(
        const SnackBar(
          content: Text("Error: Unable to reach the Train Tracked API. Are you connected to the internet?"),
        )
    );
  } on Exception catch (e) {
    log(e.toString());
    messenger?.showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString().replaceAll(apiToken, '{apiToken}')}"),
        )
    );
  }

  return null;
}

Future<List<Service>?> getDepartures(String crs, ScaffoldMessengerState? messenger) async {
  try {
    final response = await http.get(
      Uri.parse("$apiEndpoint/departures?crs=$crs"),
      headers: {
        "x-api-key": apiToken,
      }
    );

    if (response.statusCode == 200) {
      List<Service> services = [];

      for (dynamic service in jsonDecode(response.body)['services']) {
        services.add(Service.fromJson(service));
      }

      return services;
    } else {
      messenger?.showSnackBar(
          SnackBar(
            content: Text("${response.statusCode}: ${response.reasonPhrase}"),
          )
      );
    }
  } on SocketException catch (e) {
    log(e.toString());
    messenger?.showSnackBar(
        const SnackBar(
          content: Text("Error: Unable to reach the Train Tracked API. Are you connected to the internet?"),
        )
    );
  } on Exception catch (e) {
    log(e.toString());
    messenger?.showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString().replaceAll(apiToken, '{apiToken}')}"),
        )
    );
  }

  return null;
}

Future<List<Service>?> getArrivals(String crs, ScaffoldMessengerState? messenger) async {
  try {
    final response = await http.get(
      Uri.parse("$apiEndpoint/arrivals?crs=$crs"),
      headers: {
        "x-api-key": apiToken,
      }
    );

    if (response.statusCode == 200) {
      List<Service> services = [];

      for (dynamic service in jsonDecode(response.body)['services']) {
        services.add(Service.fromJson(service));
      }

      return services;
    } else {
      messenger?.showSnackBar(
          SnackBar(
            content: Text("${response.statusCode}: ${response.reasonPhrase}"),
          )
      );
    }
  } on SocketException catch (e) {
    log(e.toString());
    messenger?.showSnackBar(
      const SnackBar(
        content: Text("Error: Unable to reach the Train Tracked API. Are you connected to the internet?"),
      )
    );
  } on Exception catch (e) {
    log(e.toString());
    messenger?.showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString().replaceAll(apiToken, '{apiToken}')}"),
        )
    );
  }

  return null;
}

Future<Map<String, List<Disruption>>?> getStationDisruptions(List<String> crsList, ScaffoldMessengerState? messenger) async {
  try {
    String crsListString = "";
    for (int i = 0; i < crsList.length; i++) {
      crsListString += crsList[i] + ((i == crsList.length - 1) ? "" : ",");
    }

    final response = await http.get(
        Uri.parse("$apiEndpoint/disruptions?crs=$crsListString"),
        headers: {
          "x-api-key": apiToken,
        }
    );

    if (response.statusCode == 200) {
      Map<String, List<Disruption>>? disruptions = {};
      final result = jsonDecode(response.body)['disruptions'];

      for (String crs in crsList) {
        List<Disruption> thisDisruptions = [];

        for (dynamic item in result[crs]) {
          thisDisruptions.add(Disruption.fromJson(item));
        }

        disruptions[crs] = thisDisruptions;
      }

      return disruptions;
    } else {
      messenger?.showSnackBar(
          SnackBar(
            content: Text("${response.statusCode}: ${response.reasonPhrase}"),
          )
      );
    }
  } on SocketException catch (e) {
    log(e.toString());
    messenger?.showSnackBar(
        const SnackBar(
          content: Text("Error: Unable to reach the Train Tracked API. Are you connected to the internet?"),
        )
    );
  } on Exception catch (e) {
    log(e.toString());
    messenger?.showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString().replaceAll(apiToken, '{apiToken}')}"),
        )
    );
  }

  return null;
}