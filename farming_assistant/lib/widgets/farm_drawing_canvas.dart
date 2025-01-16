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
  Offset _viewPosition = Offset.zero;

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

  void _updateViewPosition() {
    setState(() {
      final matrix = widget.transformationController.value;
      _viewPosition = Offset(matrix[12], matrix[13]);
    });
  }

  @override
  void initState() {
    super.initState();
    widget.transformationController.addListener(_updateViewPosition);
  }

  @override
  void dispose() {
    widget.transformationController.removeListener(_updateViewPosition);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FarmStateProvider>(
      builder: (context, farmState, child) {
        return Stack(
          children: [
            // Infinite canvas with grid
            SizedBox(
              width: 10000, // Very large size for "infinite" effect
              height: 10000,
              child: CustomPaint(
                painter: GridPainter(),
              ),
            ),
            // Drawing layer
            GestureDetector(
              onTapDown: (details) {
                if (farmState.currentMode == DrawingMode.draw) {
                  widget.onTapDown(details.localPosition);
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
                size: const Size(10000, 10000),
              ),
            ),
            // Zoom controls - follow view position
            Positioned(
              left: -_viewPosition.dx + MediaQuery.of(context).size.width - 80,
              top: -_viewPosition.dy + 80,
              child: Card(
                elevation: 4,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _handleZoomIn,
                      tooltip: 'Zoom in',
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: _handleZoomOut,
                      tooltip: 'Zoom out',
                    ),
                  ],
                ),
              ),
            ),
            // Drawing controls - follow view position
            if (farmState.currentMode == DrawingMode.draw && widget.currentPoints.isNotEmpty)
              Positioned(
                left: -_viewPosition.dx + MediaQuery.of(context).size.width - 80,
                bottom: -_viewPosition.dy + 80,
                child: Card(
                  elevation: 4,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: widget.currentPoints.length >= 3 ? widget.onComplete : null,
                        tooltip: 'Complete',
                      ),
                      IconButton(
                        icon: const Icon(Icons.undo),
                        onPressed: widget.onUndo,
                        tooltip: 'Undo',
                      ),
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: widget.onClear,
                        tooltip: 'Clear',
                      ),
                    ],
                  ),
                ),
              ),
            // Instructions - follow view position
            Positioned(
              left: -_viewPosition.dx + 16,
              bottom: -_viewPosition.dy + 16,
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