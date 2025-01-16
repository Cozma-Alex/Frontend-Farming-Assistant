import 'package:flutter/material.dart';
import 'enums/location_type.dart';

/// A drawable element on the farm map representing a physical structure or area.
///
/// Each element has a unique [id], [name], and a collection of [points] defining its polygon shape.
/// Elements can be buildings, fields, ponds, or roads as specified by their [type].
/// Visual appearance is controlled by [color] and [isSelected] state.
///
/// The [animals] list tracks any animals associated with this element (primarily for buildings).
/// Additional metadata includes [notes] for user comments and [lastUpdated] timestamp.
///
/// Elements can be serialized to/from JSON for persistence using [toJson] and [fromJson].
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