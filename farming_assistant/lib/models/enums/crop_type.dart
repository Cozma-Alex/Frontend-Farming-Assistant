import 'package:flutter/material.dart';

enum CropType { nothing, grass, wheat, corn, soybeans, potatoes, vegetables }

extension CropTypeExtension on CropType {
  String get displayName => name[0].toUpperCase() + name.substring(1);

  IconData get icon {
    switch (this) {
      case CropType.wheat:
        return Icons.agriculture;
      case CropType.corn:
        return Icons.eco;
      case CropType.grass:
        return Icons.grass;
      case CropType.soybeans:
        return Icons.spa;
      case CropType.potatoes:
        return Icons.landscape;
      case CropType.vegetables:
        return Icons.local_florist;
      case CropType.nothing:
        return Icons.crop_square_outlined;
    }
  }

  Color get defaultColor {
    switch (this) {
      case CropType.grass:
        return const Color(0xFF90EE90); // Light green
      case CropType.wheat:
        return const Color(0xFFEEDD82); // Light gold
      case CropType.corn:
        return const Color(0xFFFFD700); // Gold
      case CropType.soybeans:
        return const Color(0xFF9ACD32); // Yellow green
      case CropType.potatoes:
        return const Color(0xFF8B4513); // Brown
      case CropType.vegetables:
        return const Color(0xFF228B22); // Forest green
      case CropType.nothing:
        return const Color(0xFFDCDCDC); // Light gray
    }
  }
}
