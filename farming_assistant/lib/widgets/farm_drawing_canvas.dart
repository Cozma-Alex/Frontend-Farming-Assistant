import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/farm_element.dart';
import '../utils/grid_painter.dart';
import '../utils/providers/farm_state_provider.dart';
import '../models/enums/drawing_mode.dart';
import '../models/enums/location_type.dart';
import '../utils/painters/property_painter.dart';

class FarmDrawingCanvas extends StatefulWidget {
  final List<Offset> currentPoints;
  final Function(Offset) onTapDown;
  final VoidCallback onUndo;
  final VoidCallback onClear;
  final VoidCallback onComplete;
  final TransformationController transformationController;

  const FarmDrawingCanvas({
    super.key,
    required this.currentPoints,
    required this.onTapDown,
    required this.onUndo,
    required this.onClear,
    required this.onComplete,
    required this.transformationController,
  });

  @override
  State<FarmDrawingCanvas> createState() => _FarmDrawingCanvasState();
}

class _FarmDrawingCanvasState extends State<FarmDrawingCanvas> {
  void _handleZoomIn() {
    final Matrix4 currentMatrix = widget.transformationController.value;
    final Matrix4 newMatrix = currentMatrix.clone()..scale(1.2);
    widget.transformationController.value = newMatrix;
  }

  void _handleZoomOut() {
    final Matrix4 currentMatrix = widget.transformationController.value;
    final Matrix4 newMatrix = currentMatrix.clone()..scale(0.8);
    widget.transformationController.value = newMatrix;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FarmStateProvider>(
      builder: (context, farmState, child) {
        return Stack(
          children: [
            // Massive Canvas with Grid
            SizedBox(
              width: 100000, // Much larger for more space
              height: 100000,
              child: CustomPaint(
                painter: GridPainter(),
              ),
            ),
            // Drawing Layer
            GestureDetector(
              onTapDown: (details) {
                if (farmState.currentMode == DrawingMode.draw) {
                  widget.onTapDown(details.localPosition);
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

              },
              child: CustomPaint(
                painter: PropertyPainter(
                  elements: farmState.elements,
                  selectedElement: farmState.selectedElement,
                  currentDrawing: widget.currentPoints.isNotEmpty
                      ? FarmElement(
                    id: 'temp',
                    name: 'Drawing',
                    type: farmState.selectedLocationType ?? LocationType.emptyField,
                    points: widget.currentPoints,
                    color: farmState.selectedColor,
                  )
                      : null,
                ),
                size: const Size(100000, 100000),
              ),
            ),
            // Instructions - Relative to Screen
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(16),
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

// Separate Overlay Widget for Controls
class MapControlsOverlay extends StatelessWidget {
  final FarmStateProvider farmState;
  final List<Offset> currentPoints;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onUndo;
  final VoidCallback onClear;
  final VoidCallback onComplete;

  const MapControlsOverlay({
    super.key,
    required this.farmState,
    required this.currentPoints,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onUndo,
    required this.onClear,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Zoom Controls
        Positioned(
          right: 16,
          top: 80,
          child: Card(
            elevation: 4,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: onZoomIn,
                  tooltip: 'Zoom in',
                ),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: onZoomOut,
                  tooltip: 'Zoom out',
                ),
              ],
            ),
          ),
        ),
        // Drawing Controls
        if (farmState.currentMode == DrawingMode.draw && currentPoints.isNotEmpty)
          Positioned(
            right: 16,
            bottom: 80,
            child: Card(
              elevation: 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: currentPoints.length >= 3 ? onComplete : null,
                    tooltip: 'Complete',
                  ),
                  IconButton(
                    icon: const Icon(Icons.undo),
                    onPressed: onUndo,
                    tooltip: 'Undo',
                  ),
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: onClear,
                    tooltip: 'Clear',
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}