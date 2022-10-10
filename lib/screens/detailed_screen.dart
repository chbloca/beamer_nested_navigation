import 'package:flutter/material.dart';

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
