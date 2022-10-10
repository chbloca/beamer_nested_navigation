import 'package:beamer/beamer.dart';
import 'package:beamer_nested_navigation/beam_locations/a_location.dart';
import 'package:beamer_nested_navigation/beam_locations/b_location.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _routerDelegate = BeamerDelegate(
    initialPath: '/a',
    locationBuilder: RoutesLocationBuilder(
      routes: {
        '*': (context, state, data) => const ScaffoldWithBottomNavBar(),
      },
    ),
  );

  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: _routerDelegate,
      routeInformationParser: BeamerParser(),
      backButtonDispatcher: BeamerBackButtonDispatcher(delegate: _routerDelegate),
    );
  }
}

class ScaffoldWithBottomNavBar extends StatefulWidget {
  const ScaffoldWithBottomNavBar({super.key});

  @override
  State<ScaffoldWithBottomNavBar> createState() => _ScaffoldWithBottomNavBarState();
}

class _ScaffoldWithBottomNavBarState extends State<ScaffoldWithBottomNavBar> {
  late int _currentIndex;

  final _routerDelegates = [
    BeamerDelegate(
      initialPath: '/a',
      locationBuilder: ((routeInformation, _) {
        if (routeInformation.location!.contains('/a')) {
          return ALocation(routeInformation);
        }
        return NotFound(path: routeInformation.location!);
      }),
    ),
    BeamerDelegate(
      initialPath: '/b',
      locationBuilder: ((routeInformation, _) {
        if (routeInformation.location!.contains('/b')) {
          return BLocation(routeInformation);
        }
        return NotFound(path: routeInformation.location!);
      }),
    ),
  ];

  @override
  void didChangeDependencies() {
    final uriString = Beamer.of(context).configuration.location!;
    _currentIndex = uriString.contains('/a') ? 0 : 1;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          Beamer(
            routerDelegate: _routerDelegates[0],
          ),
          Beamer(
            routerDelegate: _routerDelegates[1],
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Section A',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Section B',
          ),
        ],
        onTap: (index) {
          if (index != _currentIndex) {
            setState(() => _currentIndex = index);
            _routerDelegates[_currentIndex].update(rebuild: false);
          }
        },
      ),
    );
  }
}
