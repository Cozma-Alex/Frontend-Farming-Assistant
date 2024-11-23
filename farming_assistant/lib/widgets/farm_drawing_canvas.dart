// lib/widgets/farm_drawing_canvas.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/providers/farm_state_provider.dart';
import '../models/enums/shape_type.dart';
import '../models/enums/drawing_mode.dart';

class FarmDrawingCanvas extends StatefulWidget {
  const FarmDrawingCanvas({super.key});

  @override
  State<FarmDrawingCanvas> createState() => _FarmDrawingCanvasState();
}

class _FarmDrawingCanvasState extends State<FarmDrawingCanvas> {
  List<Offset> currentPoints = [];
  List<List<Offset>> completedPolygons = [];
  bool isDrawing = false;

  final Map<ShapeType, Color> shapeColors = {
    ShapeType.field: Colors.green.withOpacity(0.5),
    ShapeType.building: Colors.red.withOpacity(0.5),
    ShapeType.road: Colors.grey.withOpacity(0.5),
    ShapeType.pond: Colors.blue.withOpacity(0.5),
  };

  @override
  Widget build(BuildContext context) {
    return Consumer<FarmStateProvider>(
      builder: (context, farmState, child) {
        return Stack(
          children: [
            // Background with grid
            CustomPaint(
              painter: GridPainter(),
              size: Size.infinite,
            ),

            // Drawing Canvas
            GestureDetector(
              onTapDown: (details) {
                if (farmState.currentMode != DrawingMode.draw) return;
                setState(() {
                  // Add point to current polygon
                  currentPoints.add(details.localPosition);
                });
              },
              child: CustomPaint(
                painter: PolygonPainter(
                  currentPoints: currentPoints,
                  completedPolygons: completedPolygons,
                  selectedShapeType: farmState.selectedShapeType,
                  shapeColors: shapeColors,
                ),
                size: Size.infinite,
              ),
            ),

            // Tools and controls
            Positioned(
              right: 16,
              top: 16,
              child: Column(
                children: [
                  // Complete current polygon
                  IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: currentPoints.length >= 3 ? () {
                      setState(() {
                        completedPolygons.add(List.from(currentPoints));
                        currentPoints.clear();
                      });
                    } : null,
                  ),
                  // Undo last point
                  IconButton(
                    icon: const Icon(Icons.undo),
                    onPressed: currentPoints.isNotEmpty ? () {
                      setState(() {
                        currentPoints.removeLast();
                      });
                    } : null,
                  ),
                  // Clear all
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: (currentPoints.isNotEmpty || completedPolygons.isNotEmpty) ? () {
                      setState(() {
                        currentPoints.clear();
                        completedPolygons.clear();
                      });
                    } : null,
                  ),
                ],
              ),
            ),

            // Show instructions if drawing
            if (currentPoints.isNotEmpty)
              Positioned(
                left: 16,
                bottom: 16,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Click to add points. Complete with ✓',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1;

    const gridSize = 50.0;

    for (double i = 0; i < size.width; i += gridSize) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    for (double i = 0; i < size.height; i += gridSize) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PolygonPainter extends CustomPainter {
  final List<Offset> currentPoints;
  final List<List<Offset>> completedPolygons;
  final ShapeType selectedShapeType;
  final Map<ShapeType, Color> shapeColors;

  PolygonPainter({
    required this.currentPoints,
    required this.completedPolygons,
    required this.selectedShapeType,
    required this.shapeColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw completed polygons
    for (final polygon in completedPolygons) {
      _drawPolygon(canvas, polygon, true);
    }

    // Draw current polygon
    if (currentPoints.isNotEmpty) {
      _drawPolygon(canvas, currentPoints, false);
      _drawPoints(canvas, currentPoints);
    }
  }

  void _drawPolygon(Canvas canvas, List<Offset> points, bool isCompleted) {
    if (points.isEmpty) return;

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    if (isCompleted) {
      path.close();
    }

    // Draw fill
    if (isCompleted) {
      final fillPaint = Paint()
        ..color = shapeColors[selectedShapeType] ?? Colors.black.withOpacity(0.5)
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, fillPaint);
    }

    // Draw stroke
    final strokePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawPath(path, strokePaint);
  }

  void _drawPoints(Canvas canvas, List<Offset> points) {
    final pointPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    for (var point in points) {
      canvas.drawCircle(point, 5, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}