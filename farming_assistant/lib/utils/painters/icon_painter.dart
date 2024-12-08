// lib/utils/painters/icon_painter.dart
import 'package:flutter/material.dart';
import 'dart:math' show cos, pi, sin;
import '../../../models/farm_element.dart';
import '../../../models/enums/location_type.dart';
import '../../../models/enums/crop_type.dart';
import '../../../models/enums/animal_type.dart';
import '../../../models/enums/shape_type.dart';

class IconPainter extends CustomPainter {
  final List<FarmElement> elements;
  final FarmElement? selectedElement;

  IconPainter({
    required this.elements,
    this.selectedElement,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var element in elements) {
      final center = _calculateCenter(element.points);

      switch (element.shapeType) {
        case ShapeType.field:
          if (element.cropType != null) {
            _drawIcon(canvas, center, element.cropType!.icon);
          }
          break;
        case ShapeType.building:
          if (element.buildingType != null) {
            _drawIcon(canvas, center, element.buildingType!.icon);
            if (element.animals.isNotEmpty) {
              _drawAnimalIcons(canvas, center, element.animals);
            }
          }
          break;
        default:
          break;
      }
    }
  }

  Offset _calculateCenter(List<Offset> points) {
    if (points.isEmpty) return Offset.zero;

    double sumX = 0, sumY = 0;
    for (var point in points) {
      sumX += point.dx;
      sumY += point.dy;
    }
    return Offset(sumX / points.length, sumY / points.length);
  }

  void _drawIcon(Canvas canvas, Offset center, IconData iconData) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(iconData.codePoint),
        style: TextStyle(
          fontSize: 24,
          fontFamily: iconData.fontFamily,
          color: Colors.black87,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      center.translate(-textPainter.width / 2, -textPainter.height / 2),
    );
  }

  void _drawAnimalIcons(Canvas canvas, Offset center, List<AnimalType> animals) {
    const radius = 30.0;
    final count = animals.length;

    for (var i = 0; i < count; i++) {
      final angle = (2 * pi * i) / count;
      final offset = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );

      _drawIcon(canvas, offset, animals[i].icon);
    }
  }

  @override
  bool shouldRepaint(IconPainter oldDelegate) {
    return true;
  }
}