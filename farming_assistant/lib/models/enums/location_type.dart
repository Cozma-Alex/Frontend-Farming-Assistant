import 'package:flutter/material.dart';


enum LocationType {
  house,
  tractorShed,
  cowBarn,
  chickenCoop,
  pigPen,
  storage,
  other
}

extension SectionExtension on LocationType {
  String get jsonValue {
    return name.toUpperCase();
  }
}

extension BuildingTypeExtension on LocationType {
  String get displayName {
    switch (this) {
      case LocationType.tractorShed:
        return 'Tractor Shed';
      case LocationType.cowBarn:
        return 'Cow Barn';
      case LocationType.chickenCoop:
        return 'Chicken Coop';
      case LocationType.pigPen:
        return 'Pig Pen';
      default:
        return name[0].toUpperCase() + name.substring(1);
    }
  }

  IconData get icon {
    switch (this) {
      case LocationType.house:
        return Icons.home;
      case LocationType.tractorShed:
        return Icons.agriculture;
      case LocationType.cowBarn:
        return Icons.pets;
      case LocationType.chickenCoop:
        return Icons.egg;
      case LocationType.pigPen:
        return Icons.pets_outlined;
      case LocationType.storage:
        return Icons.warehouse;
      case LocationType.other:
        return Icons.business;
    }
  }
}
