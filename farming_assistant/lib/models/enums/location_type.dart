import 'package:flutter/material.dart';

enum LocationType {
  house,
  tractorShed,
  cowBarn,
  chickenCoop,
  pigPen,
  storage,
  other,
  grassField,
  wheatField,
  cornField,
  soybeansField,
  potatoesField,
  vegetablesField,
  emptyField,
  fishingPond,
  irrigationPond,
  decorativePond,
  naturalPond,
  mainRoad,
  accessPath,
  farmTrack,
  serviceRoad;

  String get jsonValue {
    switch (this) {
      case LocationType.house:
        return 'HOUSE';
      case LocationType.tractorShed:
        return 'TRACTOR_SHED';
      case LocationType.cowBarn:
        return 'COW_BARN';
      case LocationType.chickenCoop:
        return 'CHICKEN_COOP';
      case LocationType.pigPen:
        return 'PIG_PEN';
      case LocationType.storage:
        return 'STORAGE';
      case LocationType.other:
        return 'OTHER';
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
    }
  }

  String get displayName {
    switch (this) {
      case LocationType.house:
        return 'House';
      case LocationType.tractorShed:
        return 'Tractor Shed';
      case LocationType.cowBarn:
        return 'Cow Barn';
      case LocationType.chickenCoop:
        return 'Chicken Coop';
      case LocationType.pigPen:
        return 'Pig Pen';
      case LocationType.storage:
        return 'Storage';
      case LocationType.other:
        return 'Other';
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
      case LocationType.accessPath:
      case LocationType.farmTrack:
      case LocationType.serviceRoad:
        return Icons.add_road;
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

  bool get isField {
    return this == LocationType.grassField ||
        this == LocationType.wheatField ||
        this == LocationType.cornField ||
        this == LocationType.soybeansField ||
        this == LocationType.potatoesField ||
        this == LocationType.vegetablesField ||
        this == LocationType.emptyField;
  }

  bool get isBuilding {
    return this == LocationType.house ||
        this == LocationType.tractorShed ||
        this == LocationType.cowBarn ||
        this == LocationType.chickenCoop ||
        this == LocationType.pigPen ||
        this == LocationType.storage ||
        this == LocationType.other;
  }

  bool get isPond {
    return this == LocationType.fishingPond ||
        this == LocationType.irrigationPond ||
        this == LocationType.decorativePond ||
        this == LocationType.naturalPond;
  }

  bool get isRoad {
    return this == LocationType.mainRoad ||
        this == LocationType.accessPath ||
        this == LocationType.farmTrack ||
        this == LocationType.serviceRoad;
  }
}