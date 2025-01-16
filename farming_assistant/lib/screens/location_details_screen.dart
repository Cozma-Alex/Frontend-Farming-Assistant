import 'package:flutter/material.dart';
import '../models/location.dart';

class LocationDetailsScreen extends StatelessWidget {
  final Location location;

  const LocationDetailsScreen({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location ${location.id}'),
      ),
      body: Center(
        child: Text('Details for ${location.type.name} coming soon'),
      ),
    );
  }
}