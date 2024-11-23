import 'package:flutter/material.dart';

enum CropType {
  nothing,
  grass,
  wheat,
  corn,
  soybeans,
  potatoes,
  vegetables
}

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
}