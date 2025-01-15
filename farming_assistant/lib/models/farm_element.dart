import 'package:flutter/material.dart';
import 'enums/animal_type.dart';
import 'enums/location_type.dart';
import 'enums/crop_type.dart';
import 'enums/pond_type.dart';
import 'enums/road_type.dart';
import 'enums/shape_type.dart';

class FarmElement {
  final String id;
  String name;
  final ShapeType shapeType;
  List<Offset> points;
  Color color;
  bool isSelected;
  CropType? cropType;
  LocationType? buildingType;
  PondType? pondType;
  RoadType? roadType;
  List<AnimalType> animals;
  String? notes;
  DateTime lastUpdated;

  FarmElement({
    required this.id,
    required this.name,
    required this.shapeType,
    required this.points,
    required this.color,
    this.isSelected = false,
    this.cropType,
    this.buildingType,
    this.pondType,
    this.roadType,
    List<AnimalType>? animals,
    this.notes,
    DateTime? lastUpdated,
  }) :
        animals = animals ?? [],
        lastUpdated = lastUpdated ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'shapeType': shapeType.toString(),
      'points': points.map((p) => {'x': p.dx, 'y': p.dy}).toList(),
      'color': color.value,
      'cropType': cropType?.toString(),
      'buildingType': buildingType?.toString(),
      'pondType': pondType?.toString(),
      'roadType': roadType?.toString(),
      'animals': animals.map((a) => a.toString()).toList(),
      'notes': notes,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory FarmElement.fromJson(Map<String, dynamic> json) {
    return FarmElement(
      id: json['id'],
      name: json['name'],
      shapeType: ShapeType.values.firstWhere(
            (e) => e.toString() == json['shapeType'],
      ),
      points: (json['points'] as List).map((p) =>
          Offset(p['x'] as double, p['y'] as double)
      ).toList(),
      color: Color(json['color'] as int),
      cropType: json['cropType'] != null
          ? CropType.values.firstWhere(
            (e) => e.toString() == json['cropType'],
      )
          : null,
      buildingType: json['buildingType'] != null
          ? LocationType.values.firstWhere(
            (e) => e.toString() == json['buildingType'],
      )
          : null,
      pondType: json['pondType'] != null
          ? PondType.values.firstWhere(
            (e) => e.toString() == json['pondType'],
      )
          : null,
      roadType: json['roadType'] != null
          ? RoadType.values.firstWhere(
            (e) => e.toString() == json['roadType'],
      )
          : null,
      animals: (json['animals'] as List).map((a) =>
          AnimalType.values.firstWhere(
                (e) => e.toString() == a,
          ),
      ).toList(),
      notes: json['notes'],
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }

  void updateColor(Color newColor) {
    color = newColor;
  }
}
