import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/providers/farm_state_provider.dart';
import '../widgets/locations_section_widget.dart';
import '../widgets/property_map_view.dart';
import 'barns_screen.dart';
import 'fields_screen.dart';
import 'tools_screen.dart';
import 'storage_screen.dart';
import '../utils/providers/logged_user_provider.dart';

/// A widget that displays the interactive farm property map and location management interface.
///
/// Main features:
/// - Interactive map view with a button to open full [PropertyMapView]
/// - Navigation buttons for different property sections (Fields, Barns, Storage, Tools)
/// - Grid of location cards showing saved property locations
///
/// Layout structure:
/// - Main map container takes 50% of screen height
/// - Navigation bar with section buttons
/// - Location cards grid at bottom with pagination dots
///
/// The map view uses [FarmStateProvider] for managing map state and elements.
/// Location data is loaded asynchronously on initialization.
///
/// Navigation:
/// - Section buttons navigate to specialized screens ([FieldsScreen], [BarnsScreen], etc.)
/// - Map button opens full [PropertyMapView] for detailed editing
/// - Location cards open [LocationDetailsScreen] for each location
class MapContent extends StatelessWidget {
  const MapContent({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Container(
                  height: constraints.maxHeight * 0.5,
                  margin: const EdgeInsets.only(bottom: 25, top: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        final loggedUser = Provider.of<LoggedUserProvider>(context, listen: false).user;
                        if (loggedUser != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangeNotifierProvider(
                                create: (_) => FarmStateProvider(),
                                child: const PropertyMapView(),
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text('Open Map'),
                    ),
                  ),
                ),
                Container(
                  height: constraints.maxHeight * 0.1,
                  margin: const EdgeInsets.only(bottom: 25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildMapButton('Fields', Icons.eco, context),
                          _buildMapButton('Barns', Icons.pets, context),
                          _buildMapButton('Storage', Icons.restaurant, context),
                          _buildMapButton(
                              'Tools', Icons.handyman_outlined, context),
                        ]),
                  ),
                ),
                Container(
                  height: constraints.maxHeight * 0.26,
                  child: LocationsSection(height: constraints.maxHeight * 0.26),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMapButton(String label, IconData icon, BuildContext context) {
    return GestureDetector(
      onTap: () {
        switch (label) {
          case 'Fields':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FieldsScreen()),
            );
            break;
          case 'Barns':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BarnsScreen()),
            );
            break;
          case 'Storage':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const StorageScreen()),
            );
            break;
          case 'Tools':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ToolsScreen()),
            );
            break;
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFF31511E),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF838383),
            ),
          ),
        ],
      ),
    );
  }
}