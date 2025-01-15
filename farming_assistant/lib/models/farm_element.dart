import 'package:flutter/material.dart';
import 'enums/location_type.dart';

class FarmElement {
  final String id;
  String name;
  LocationType type;
  List<Offset> points;
  Color color;
  bool isSelected;
  String? notes;
  DateTime lastUpdated;

  FarmElement({
    required this.id,
    required this.name,
    required this.type,
    required this.points,
    required this.color,
    this.isSelected = false,
    this.notes,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.jsonValue,
      'points': points.map((p) => {'x': p.dx, 'y': p.dy}).toList(),
      'color': color.value,
      'notes': notes,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory FarmElement.fromJson(Map<String, dynamic> json) {
    return FarmElement(
      id: json['id'],
      name: json['name'],
      type: LocationType.values.firstWhere(
            (e) => e.jsonValue == json['type'],
      ),
      points: (json['points'] as List).map((p) =>
          Offset(p['x'] as double, p['y'] as double)
      ).toList(),
      color: Color(json['color'] as int),
      notes: json['notes'],
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }

  void updateColor(Color newColor) {
    color = newColor;
  }
}