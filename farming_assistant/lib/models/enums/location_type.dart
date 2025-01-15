import 'package:flutter/material.dart';

enum LocationType {
  // Buildings
  house,
  tractorShed,
  cowBarn,
  chickenCoop,
  pigPen,
  storage,
  other,

  // Fields
  grassField,
  wheatField,
  cornField,
  soybeansField,
  potatoesField,
  vegetablesField,
  emptyField,

  // Ponds
  fishingPond,
  irrigationPond,
  decorativePond,
  naturalPond,

  // Roads
  mainRoad,
  accessPath,
  farmTrack,
  serviceRoad
}

extension LocationTypeExtension on LocationType {
  String get jsonValue {
    switch (this) {
      case LocationType.tractorShed:
        return 'TRACTOR_SHED';
      case LocationType.cowBarn:
        return 'COW_BARN';
      case LocationType.chickenCoop:
        return 'CHICKEN_COOP';
      case LocationType.pigPen:
        return 'PIG_PEN';
      case LocationType.grassField:
        return 'GRASS_FIELD';
      case LocationType.wheatField:
        return 'WHEAT_FIELD';
      case LocationType.cornField:
        return 'CORN_FIELD';
      case LocationType.soybeansField:
        return 'SOYBEANS_FIELD';
      case LocationType.potatoesField:
        return 'POTATOES_FIELD';
      case LocationType.vegetablesField:
        return 'VEGETABLES_FIELD';
      case LocationType.emptyField:
        return 'EMPTY_FIELD';
      case LocationType.fishingPond:
        return 'FISHING_POND';
      case LocationType.irrigationPond:
        return 'IRRIGATION_POND';
      case LocationType.decorativePond:
        return 'DECORATIVE_POND';
      case LocationType.naturalPond:
        return 'NATURAL_POND';
      case LocationType.mainRoad:
        return 'MAIN_ROAD';
      case LocationType.accessPath:
        return 'ACCESS_PATH';
      case LocationType.farmTrack:
        return 'FARM_TRACK';
      case LocationType.serviceRoad:
        return 'SERVICE_ROAD';
      default:
        return name.toUpperCase();
    }
  }

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
      case LocationType.grassField:
        return 'Grass Field';
      case LocationType.wheatField:
        return 'Wheat Field';
      case LocationType.cornField:
        return 'Corn Field';
      case LocationType.soybeansField:
        return 'Soybeans Field';
      case LocationType.potatoesField:
        return 'Potatoes Field';
      case LocationType.vegetablesField:
        return 'Vegetables Field';
      case LocationType.emptyField:
        return 'Empty Field';
      case LocationType.fishingPond:
        return 'Fishing Pond';
      case LocationType.irrigationPond:
        return 'Irrigation Pond';
      case LocationType.decorativePond:
        return 'Decorative Pond';
      case LocationType.naturalPond:
        return 'Natural Pond';
      case LocationType.mainRoad:
        return 'Main Road';
      case LocationType.accessPath:
        return 'Access Path';
      case LocationType.farmTrack:
        return 'Farm Track';
      case LocationType.serviceRoad:
        return 'Service Road';
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
      case LocationType.grassField:
      case LocationType.wheatField:
      case LocationType.cornField:
      case LocationType.soybeansField:
      case LocationType.potatoesField:
      case LocationType.vegetablesField:
      case LocationType.emptyField:
        return Icons.grass;
      case LocationType.fishingPond:
      case LocationType.irrigationPond:
      case LocationType.decorativePond:
      case LocationType.naturalPond:
        return Icons.water;
      case LocationType.mainRoad:
        return Icons.add_road;
      case LocationType.accessPath:
        return Icons.directions_walk;
      case LocationType.farmTrack:
        return Icons.agriculture;
      case LocationType.serviceRoad:
        return Icons.local_shipping;
    }
  }

  Color get defaultColor {
    switch (this) {
      case LocationType.house:
        return const Color(0xFFCD853F);
      case LocationType.tractorShed:
        return const Color(0xFFDEB887);
      case LocationType.cowBarn:
        return const Color(0xFFA0522D);
      case LocationType.chickenCoop:
        return const Color(0xFFD2691E);
      case LocationType.pigPen:
        return const Color(0xFF8B4513);
      case LocationType.storage:
        return const Color(0xFFDAA520);
      case LocationType.other:
        return const Color(0xFFBC8F8F);
      case LocationType.grassField:
        return const Color(0xFF90EE90);
      case LocationType.wheatField:
        return const Color(0xFFEEDD82);
      case LocationType.cornField:
        return const Color(0xFFFFD700);
      case LocationType.soybeansField:
        return const Color(0xFF9ACD32);
      case LocationType.potatoesField:
        return const Color(0xFF8B4513);
      case LocationType.vegetablesField:
        return const Color(0xFF228B22);
      case LocationType.emptyField:
        return const Color(0xFFDCDCDC);
      case LocationType.fishingPond:
        return const Color(0xFF4682B4);
      case LocationType.irrigationPond:
        return const Color(0xFF87CEEB);
      case LocationType.decorativePond:
        return const Color(0xFF00CED1);
      case LocationType.naturalPond:
        return const Color(0xFF1E90FF);
      case LocationType.mainRoad:
        return const Color(0xFF808080);
      case LocationType.accessPath:
        return const Color(0xFFA9A9A9);
      case LocationType.farmTrack:
        return const Color(0xFFD3D3D3);
      case LocationType.serviceRoad:
        return const Color(0xFF696969);
    }
  }
}