import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

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
