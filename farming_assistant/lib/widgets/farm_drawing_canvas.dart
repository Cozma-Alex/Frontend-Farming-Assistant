import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/farm_element.dart';
import '../utils/providers/farm_state_provider.dart';
import '../models/enums/drawing_mode.dart';
import '../models/enums/location_type.dart';
import '../utils/painters/property_painter.dart';

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

class FarmDrawingCanvas extends StatelessWidget {
  final List<Offset> currentPoints;
  final Function(Offset) onTapDown;
  final VoidCallback onUndo;
  final VoidCallback onClear;
  final VoidCallback onComplete;

  const FarmDrawingCanvas({
    super.key,
    required this.currentPoints,
    required this.onTapDown,
    required this.onUndo,
    required this.onClear,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<FarmStateProvider>(
      builder: (context, farmState, child) {
        return Stack(
          children: [
            CustomPaint(
              painter: GridPainter(),
              size: Size.infinite,
            ),
            GestureDetector(
              onTapDown: (details) {
                if (farmState.currentMode == DrawingMode.draw) {
                  onTapDown(details.localPosition);
                } else if (farmState.currentMode == DrawingMode.edit ||
                    farmState.currentMode == DrawingMode.color) {
                  if (farmState.selectedElement != null) {
                    final element = farmState.selectedElement!;
                    for (var i = 0; i < element.points.length; i++) {
                      if ((element.points[i] - details.localPosition).distance < 20) {
                        return;
                      }
                    }
                  }

                  for (var element in farmState.elements) {
                    if (_isPointInPolygon(details.localPosition, element.points)) {
                      farmState.selectElement(element);
                      if (farmState.currentMode == DrawingMode.color) {
                        farmState.setSelectedColor(farmState.selectedColor);
                      }
                      break;
                    }
                  }
                } else if (farmState.currentMode == DrawingMode.delete) {
                  for (var element in farmState.elements) {
                    if (_isPointInPolygon(details.localPosition, element.points)) {
                      farmState.deleteElement(element.id);
                      break;
                    }
                  }
                }
              },
              onPanUpdate: (details) {
                if (farmState.currentMode == DrawingMode.edit &&
                    farmState.selectedElement != null) {
                  final element = farmState.selectedElement!;
                  List<Offset> newPoints = List.from(element.points);

                  FarmElement updatedElement = FarmElement(
                    id: element.id,
                    name: element.name,
                    type: element.type,
                    points: newPoints,
                    color: element.color,
                  );

                  farmState.updateElement(updatedElement);
                }
              },
              child: CustomPaint(
                painter: PropertyPainter(
                  elements: farmState.elements,
                  selectedElement: farmState.selectedElement,
                  currentDrawing: currentPoints.isNotEmpty
                      ? FarmElement(
                    id: 'temp',
                    name: 'Drawing',
                    type: farmState.selectedLocationType ?? LocationType.emptyField,
                    points: currentPoints,
                    color: farmState.selectedColor,
                  )
                      : null,
                ),
                size: Size.infinite,
              ),
            ),
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
                  _getInstructionText(farmState.currentMode),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String _getInstructionText(DrawingMode mode) {
    switch (mode) {
      case DrawingMode.draw:
        return 'Click to add points. Complete with ✓';
      case DrawingMode.edit:
        return 'Click shape to select, then drag points to edit';
      case DrawingMode.delete:
        return 'Click on a shape to delete it';
      case DrawingMode.view:
        return 'View mode';
      case DrawingMode.color:
        return 'Click on a shape to change its color';
    }
  }

  bool _isPointInPolygon(Offset point, List<Offset> vertices) {
    bool isInside = false;
    int j = vertices.length - 1;

    for (int i = 0; i < vertices.length; i++) {
      if (((vertices[i].dy > point.dy) != (vertices[j].dy > point.dy)) &&
          (point.dx < (vertices[j].dx - vertices[i].dx) * (point.dy - vertices[i].dy) /
              (vertices[j].dy - vertices[i].dy) +
              vertices[i].dx)) {
        isInside = !isInside;
      }
      j = i;
    }

    return isInside;
  }
}