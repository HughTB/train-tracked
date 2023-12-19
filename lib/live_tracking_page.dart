import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:train_tracked/api.dart';

import 'main.dart';
import 'service.dart';
import 'services_search.dart';
import 'stations_search.dart';
import 'stations.g.dart';

class LiveTrackingPage extends StatefulWidget {
  const LiveTrackingPage({super.key, required this.service, required this.oldService});

  final Service service;
  final bool oldService;

  @override
  State<LiveTrackingPage> createState() => _LiveTrackingPageState(service, oldService);
}

class _LiveTrackingPageState extends State<LiveTrackingPage> {
  Service service;
  bool oldService;

  _LiveTrackingPageState(this.service, this.oldService);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getServiceView(context, service, !oldService),
      initialData: <Widget>[Container(
        height: 200,
        alignment: Alignment.center,
        child: SpinKitFoldingCube(
          color: Theme.of(context).primaryColorLight,
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
              children: serviceView.data!,
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