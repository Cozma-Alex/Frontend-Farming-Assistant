import 'package:flutter/material.dart';


enum BuildingType {
  house,
  tractorShed,
  cowBarn,
  chickenCoop,
  pigPen,
  storage,
  other
}

extension BuildingTypeExtension on BuildingType {
  String get displayName {
    switch (this) {
      case BuildingType.tractorShed:
        return 'Tractor Shed';
      case BuildingType.cowBarn:
        return 'Cow Barn';
      case BuildingType.chickenCoop:
        return 'Chicken Coop';
      case BuildingType.pigPen:
        return 'Pig Pen';
      default:
        return name[0].toUpperCase() + name.substring(1);
    }
  }

  IconData get icon {
    switch (this) {
      case BuildingType.house:
        return Icons.home;
      case BuildingType.tractorShed:
        return Icons.agriculture;
      case BuildingType.cowBarn:
        return Icons.pets;
      case BuildingType.chickenCoop:
        return Icons.egg;
      case BuildingType.pigPen:
        return Icons.pets_outlined;
      case BuildingType.storage:
        return Icons.warehouse;
      case BuildingType.other:
        return Icons.business;
    }
  }
}
