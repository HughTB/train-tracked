import 'package:flutter/material.dart';

// Settings toggle variables
bool _platformNotif = false;
bool _delayNotif = false;
bool _cancellationNotif = false;

const List<DropdownMenuEntry> homeStationEntries = <DropdownMenuEntry>[
  DropdownMenuEntry(
    value: 'SOU',
    label: 'Southampton Central (SOU)',
  ),
  DropdownMenuEntry(
    value: 'SOA',
    label: 'Southampton Airport Parkway (SOA)',
  ),
  DropdownMenuEntry(
    value: 'PMS',
    label: 'Portsmouth & Southsea (PMS)',
  ),
];

// Nav bar items to show at the bottom of all screens
const List<NavigationDestination> navBarItems = <NavigationDestination>[
  NavigationDestination(
    icon: Icon(Icons.home_outlined),
    selectedIcon: Icon(Icons.home),
    label: 'Home',
  ),
  NavigationDestination(
    icon: Icon(Icons.train_outlined),
    selectedIcon: Icon(Icons.train),
    label: 'Live Trains',
  ),
  NavigationDestination(
    icon: Icon(Icons.settings_outlined),
    selectedIcon: Icon(Icons.settings),
    label: 'Settings',
  ),
];

// The currently selected screen
int currentNavIndex = 0;
// Get the route to navigate to, given an index
String getNavRoute(int index) {
  currentNavIndex = index; // Set the selected screen

  switch(index) {
    case 0:
      return '/';
    case 1:
      return '/live-trains';
    case 2:
      return '/settings';
    default:
      return '/';
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Train Tracked',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8635E3), brightness: Brightness.light),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8635E3), brightness: Brightness.dark),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system, // Follow system theme
      home: const HomePage(title: 'Home'),
      routes: <String, WidgetBuilder>{
        "/live-trains": (context) => const LiveTrainsPage(title: 'Live Trains'),
        "/settings": (context) => const SettingsPage(title: 'Settings'),
      },
    );
  }
}

// Home page
class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Home Page',
            ),
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

// Live Trains page
class LiveTrainsPage extends StatefulWidget {
  const LiveTrainsPage({super.key, required this.title});

  final String title;

  @override
  State<LiveTrainsPage> createState() => _LiveTrainsPageState();
}

class _LiveTrainsPageState extends State<LiveTrainsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Live Trains',
            ),
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

// Settings page
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.title});

  final String title;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
          children: [
            const DropdownMenu(
              label: Text('Home Station'),
              dropdownMenuEntries: homeStationEntries,
            ),
            const Divider(),
            Text(
              'Notifications',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SwitchListTile(
              title: const Text('Platform Change'),
              subtitle: const Text('Send a notification if a saved train changes platform'),
              value: _platformNotif,
              onChanged: (bool value) {
                setState(() {
                  _platformNotif = value;
                });
              }
            ),
            SwitchListTile(
                title: const Text('Train Delay'),
                subtitle: const Text('Send a notification if a saved train is delayed by more than 5 minutes'),
                value: _delayNotif,
                onChanged: (bool value) {
                  setState(() {
                    _delayNotif = value;
                  });
                }
            ),
            SwitchListTile(
                title: const Text('Train Cancellation'),
                subtitle: const Text('Send a notification if a saved train is cancelled'),
                value: _cancellationNotif,
                onChanged: (bool value) {
                  setState(() {
                    _cancellationNotif = value;
                  });
                }
            ),
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