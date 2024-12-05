import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/providers/farm_state_provider.dart';
import '../widgets/property_map_view.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PropertyMapView(),
    );
  }
}