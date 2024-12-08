import 'package:flutter/material.dart';

enum RoadType { mainRoad, accessPath, farmTrack, serviceRoad }

extension RoadTypeExtension on RoadType {
  String get displayName {
    switch (this) {
      case RoadType.mainRoad:
        return 'Main Road';
      case RoadType.accessPath:
        return 'Access Path';
      case RoadType.farmTrack:
        return 'Farm Track';
      case RoadType.serviceRoad:
        return 'Service Road';
    }
  }

  IconData get icon {
    switch (this) {
      case RoadType.mainRoad:
        return Icons.add_road;
      case RoadType.accessPath:
        return Icons.directions_walk;
      case RoadType.farmTrack:
        return Icons.agriculture;
      case RoadType.serviceRoad:
        return Icons.local_shipping;
    }
  }

  Color get defaultColor {
    switch (this) {
      case RoadType.mainRoad:
        return const Color(0xFF808080); // Gray
      case RoadType.accessPath:
        return const Color(0xFFA9A9A9); // Dark gray
      case RoadType.farmTrack:
        return const Color(0xFFD3D3D3); // Light gray
      case RoadType.serviceRoad:
        return const Color(0xFF696969); // Dim gray
    }
  }
}
