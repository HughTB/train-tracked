import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:train_tracked/api/api.dart';

import '../main.dart';
import '../classes/service.dart';
import '../helpers/services_search.dart';
import '../helpers/stations_search.dart';
import '../classes/station_list.g.dart';

class ServiceViewPage extends StatefulWidget {
  const ServiceViewPage({super.key, required this.service, required this.oldService});

  final Service service;
  final bool oldService;

  @override
  State<ServiceViewPage> createState() => _ServiceViewPageState(service, oldService);
}

class _ServiceViewPageState extends State<ServiceViewPage> {
  Service service;
  bool oldService;

  _ServiceViewPageState(this.service, this.oldService);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getServiceView(context, service, !oldService),
      initialData: <Widget>[Container(
        height: 200,
        alignment: Alignment.center,
        child: SpinKitFoldingCube(
          color: Theme.of(context).textTheme.bodyMedium?.color,
        ),
      )],
      builder: (BuildContext context, AsyncSnapshot<List<Widget>> serviceView) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text("to ${getStationByCrs(stations, (service.stoppingPoints.isEmpty) ? service.destination.first : (service.stoppingPoints.last.crs))?.stationName}"),
            actions: [
              IconButton(
                  icon: (savedServicesBox.get(service.rid) != null) ? const Icon(Icons.save) : const Icon(Icons.save_outlined),
                  tooltip: 'Save Service',
                  onPressed: () async {
                    if (savedServicesBox.get(service.rid) == null) {
                      service = await getServiceDetails(service.rid, ScaffoldMessenger.of(context)) ?? service;
                    }
                    setState(() {
                      if (savedServicesBox.get(service.rid) != null) {
                        savedServicesBox.put(service.rid, null);
                      } else {
                        savedServicesBox.put(service.rid, service);
                      }
                    });
                  }
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: (serviceView.data == null) ? [] : serviceView.data!,
            ),
          ),
          bottomNavigationBar: NavigationBar(
              destinations: navBarItems,
              selectedIndex: currentNavIndex,
              indicatorColor: Theme.of(context).colorScheme.inversePrimary,
              onDestinationSelected: (int index) {
                if (index != currentNavIndex) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.pushReplacementNamed(context, getNavRoute(index));
                }
              }
          ),
        );
      }
    );
  }
}