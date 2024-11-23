import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/providers/farm_state_provider.dart';
import '../widgets/element_details_panel.dart';
import '../widgets/element_list_panel.dart';
import '../widgets/map_toolbox.dart';
import '../widgets/property_map_view.dart';

class FarmManagementPage extends StatelessWidget {
  const FarmManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farm Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => context.read<FarmStateProvider>().saveFarmData(),
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showLegend(context),
          ),
        ],
      ),
      body: const Row(
        children: [
          SizedBox(
            width: 300,
            child: Column(
              children: [
                MapToolbox(),
                ElementDetailsPanel(),
                Expanded(child: ElementListPanel()),
              ],
            ),
          ),
          Expanded(
            child: PropertyMapView(),
          ),
        ],
      ),
    );
  }

  void _showLegend(BuildContext context) {
    // Implementation
  }
}