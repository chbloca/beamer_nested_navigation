import 'package:beamer/beamer.dart';
import 'package:beamer_nested_navigation/screens/detailed_screen.dart';
import 'package:beamer_nested_navigation/screens/root_screen.dart';
import 'package:flutter/material.dart';

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
