import 'package:flutter/material.dart';

enum PondType { fishing, irrigation, decorative, natural }

extension PondTypeExtension on PondType {
  String get displayName {
    switch (this) {
      case PondType.fishing:
        return 'Fishing Pond';
      case PondType.irrigation:
        return 'Irrigation Pond';
      case PondType.decorative:
        return 'Decorative Pond';
      case PondType.natural:
        return 'Natural Pond';
    }
  }

  IconData get icon {
    switch (this) {
      case PondType.fishing:
        return Icons.catching_pokemon;
      case PondType.irrigation:
        return Icons.water_drop;
      case PondType.decorative:
        return Icons.wb_sunny;
      case PondType.natural:
        return Icons.landscape;
    }
  }

  Color get defaultColor {
    switch (this) {
      case PondType.fishing:
        return const Color(0xFF4682B4); // Steel blue
      case PondType.irrigation:
        return const Color(0xFF87CEEB); // Sky blue
      case PondType.decorative:
        return const Color(0xFF00CED1); // Turquoise
      case PondType.natural:
        return const Color(0xFF1E90FF); // Dodger blue
    }
  }
}
