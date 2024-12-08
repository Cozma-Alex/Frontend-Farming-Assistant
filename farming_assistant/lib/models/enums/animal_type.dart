import 'package:flutter/material.dart';


enum AnimalType {
  none,
  cattle,
  chickens,
  pigs,
  sheep,
  horses
}

extension AnimalTypeExtension on AnimalType {
  String get displayName => name[0].toUpperCase() + name.substring(1);

  IconData get icon {
    switch (this) {
      case AnimalType.cattle:
        return Icons.pets;
      case AnimalType.chickens:
        return Icons.egg_alt;
      case AnimalType.pigs:
        return Icons.pets_outlined;
      case AnimalType.sheep:
        return Icons.pets;
      case AnimalType.horses:
        return Icons.cruelty_free;
      case AnimalType.none:
        return Icons.not_interested;
    }
  }
}