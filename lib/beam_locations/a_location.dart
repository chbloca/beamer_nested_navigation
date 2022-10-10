import 'package:beamer/beamer.dart';
import 'package:beamer_nested_navigation/screens/detailed_screen.dart';
import 'package:beamer_nested_navigation/screens/root_screen.dart';
import 'package:flutter/material.dart';

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
