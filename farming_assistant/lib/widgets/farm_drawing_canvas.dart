import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/farm_element.dart';
import '../utils/grid_painter.dart';
import '../utils/providers/farm_state_provider.dart';
import '../models/enums/drawing_mode.dart';
import '../models/enums/location_type.dart';
import '../utils/painters/property_painter.dart';

/// Interactive canvas widget for drawing and editing farm property elements.
///
/// Core functionalities:
/// - Drawing new shapes by adding points on tap
/// - Editing existing elements via vertex manipulation
/// - Selecting elements for editing/deletion
/// - Real-time preview of current drawing
///
/// Required parameters:
/// - [currentPoints]: List of points for current drawing
/// - [onTapDown]: Callback for handling tap events
/// - [onUndo]: Callback to remove last point
/// - [onClear]: Callback to clear current drawing
/// - [onComplete]: Callback when drawing is completed
///
/// Interaction modes (via [FarmStateProvider]):
/// - View: Pan and zoom map
/// - Draw: Add points to create new elements
/// - Edit: Modify existing element vertices
/// - Delete: Remove elements
///
/// Features:
/// - Grid background for reference
/// - Selection highlighting
/// - Vertex manipulation for editing
/// - Mode-specific instructions display
/// - Point-in-polygon detection for selection
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

/// An overlay widget that provides map control buttons for zoom and drawing operations.
///
/// Displays two sets of controls:
/// - Zoom controls (always visible): Zoom in/out buttons
/// - Drawing controls (visible only in draw mode with active points): Complete, undo, clear
///
/// Required parameters:
/// - [farmState]: Provider for tracking current drawing mode and state
/// - [currentPoints]: List of points in current drawing
/// - [onZoomIn]: Callback to handle zoom in
/// - [onZoomOut]: Callback to handle zoom out
/// - [onUndo]: Callback to remove last drawn point
/// - [onClear]: Callback to clear all current points
/// - [onComplete]: Callback to finalize drawing (enabled with 3+ points)
///
/// UI Features:
/// - Floating cards with elevation for visual hierarchy
/// - Tool tips for button explanations
/// - Disabled states for invalid operations
/// - Positioned away from main drawing area
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