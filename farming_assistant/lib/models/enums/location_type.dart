import 'package:flutter/material.dart';

enum LocationType {
  house,
  tractorShed,
  cowBarn,
  chickenCoop,
  pigPen,
  storage,
  other, field, barn, tools
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
      case LocationType.field:
        return Icons.grass;
      case LocationType.barn:
        return Icons.home_work;
      case LocationType.tools:
        return Icons.handyman;
    }
  }

  Color get defaultColor {
    switch (this) {
      case LocationType.house:
        return const Color(0xFFCD853F); // Light brown
      case LocationType.tractorShed:
        return const Color(0xFFDEB887); // Brown wood
      case LocationType.cowBarn:
        return const Color(0xFFA0522D); // Brown
      case LocationType.chickenCoop:
        return const Color(0xFFD2691E); // Orange brown
      case LocationType.pigPen:
        return const Color(0xFF8B4513); // Dark brown
      case LocationType.storage:
        return const Color(0xFFDAA520); // Golden brown
      case LocationType.other:
        return const Color(0xFFBC8F8F); // Light brown
      case LocationType.field:
        return const Color(0xFF96DD7E);
      case LocationType.barn:
        return const Color(0xFF652600);
      case LocationType.tools:
        return const Color(0x8BAFAFAF);
    }
  }
}
