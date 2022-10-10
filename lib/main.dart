import 'package:beamer/beamer.dart';
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

class DetailsScreen extends StatefulWidget {
  final String label;
  const DetailsScreen({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details Screen - ${widget.label}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Details for ${widget.label} - Counter: $counter'),
            TextButton(
              onPressed: () => setState(() => counter++),
              child: const Text('Increment counter'),
            ),
          ],
        ),
      ),
    );
  }
}

class RootScreen extends StatelessWidget {
  final String label;
  final String detailsPath;

  const RootScreen({
    Key? key,
    required this.label,
    required this.detailsPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tab Root - $label'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Screen $label'),
            TextButton(
              onPressed: () {
                context.beamToNamed(detailsPath);
              },
              child: const Text('View details'),
            ),
          ],
        ),
      ),
    );
  }
}

class ALocation extends BeamLocation<BeamState> {
  ALocation(super.routeInformation);

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        const BeamPage(
          key: ValueKey('a'),
          title: 'Tab A',
          type: BeamPageType.noTransition,
          child: RootScreen(label: 'A', detailsPath: '/a/details'),
        ),
        if (state.uri.pathSegments.length == 2)
          const BeamPage(
            key: ValueKey('a/details'),
            title: 'Details A',
            child: DetailsScreen(label: 'A'),
          )
      ];

  @override
  List<Pattern> get pathPatterns => ['/*'];
}

class BLocation extends BeamLocation<BeamState> {
  BLocation(super.routeInformation);

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        const BeamPage(
          key: ValueKey('b'),
          title: 'Tab B',
          type: BeamPageType.noTransition,
          child: RootScreen(label: 'B', detailsPath: '/b/details'),
        ),
        if (state.uri.pathSegments.length == 2)
          const BeamPage(
            key: ValueKey('b/details'),
            title: 'Details B',
            child: DetailsScreen(label: 'B'),
          )
      ];

  @override
  List<Pattern> get pathPatterns => ['/*'];
}
