import 'package:flutter/material.dart';
import '../../models/farm_element.dart';

class PropertyPainter extends CustomPainter {
  final List<FarmElement> elements;
  final FarmElement? selectedElement;
  final FarmElement? currentDrawing;
  final double gridSize;

  PropertyPainter({
    required this.elements,
    this.selectedElement,
    this.currentDrawing,
    this.gridSize = 50.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawGrid(canvas, size);

    for (var element in elements) {
      _drawElement(canvas, element, element == selectedElement);
    }

    if (currentDrawing != null) {
      _drawElement(canvas, currentDrawing!, true, isDraft: true);
    }
  }

  void _drawGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1;

    // Draw vertical lines
    for (double i = 0; i < size.width; i += gridSize) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, size.height),
        paint,
      );
    }

    // Draw horizontal lines
    for (double i = 0; i < size.height; i += gridSize) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        paint,
      );
    }
  }

  void _drawElement(
      Canvas canvas,
      FarmElement element,
      bool isSelected, {
        bool isDraft = false,
      }) {
    if (element.points.isEmpty) return;

    final path = Path();
    path.moveTo(element.points.first.dx, element.points.first.dy);

    for (var point in element.points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }

    if (!isDraft) {
      path.close();
    }

    // Fill
    final fillPaint = Paint()
      ..color = element.color.withOpacity(isDraft ? 0.3 : 0.5) // Use element.color
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    // Stroke
    final strokePaint = Paint()
      ..color = isSelected ? Colors.blue : element.color // Use element.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = isSelected ? 3 : 2;
    canvas.drawPath(path, strokePaint);

    // Draw vertices for selected elements
    if (isSelected) {
      final vertexPaint = Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.fill;

      for (var point in element.points) {
        canvas.drawCircle(point, 5, vertexPaint);
      }
    }
  }

  @override
  bool shouldRepaint(PropertyPainter oldDelegate) {
    return true;
  }
}