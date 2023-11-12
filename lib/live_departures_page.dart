import 'package:flutter/material.dart';

import 'main.dart';

class LiveDeparturesPage extends StatefulWidget {
  const LiveDeparturesPage({super.key, required this.title, required this.crs});

  final String title;
  final String crs;

  @override
  State<LiveDeparturesPage> createState() => _LiveDeparturesPageState();
}

class _LiveDeparturesPageState extends State<LiveDeparturesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: const [
            Text('lmao all the trains are cancelled 😢'),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
          destinations: navBarItems,
          selectedIndex: currentNavIndex,
          indicatorColor: Theme.of(context).colorScheme.inversePrimary,
          onDestinationSelected: (int index) {
            if (index != currentNavIndex) {
              Navigator.pushReplacementNamed(context, getNavRoute(index));
            }
          }
      ),
    );
  }
}