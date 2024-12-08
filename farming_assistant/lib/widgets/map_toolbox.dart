import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/providers/farm_state_provider.dart';
import '../models/enums/drawing_mode.dart';
import '../models/enums/shape_type.dart';

import 'color_picker_overlay.dart';

class MapToolbox extends StatefulWidget {
  const MapToolbox({super.key});

  @override
  State<MapToolbox> createState() => _MapToolboxState();
}

class _MapToolboxState extends State<MapToolbox> {
  bool _showColorPicker = false;

  final List<Color> presetColors = const [
    // Greens
    Color(0xFFA7D77C),
    Color(0xFF69A84F),
    Color(0xFF2E5A1C),
    // Blues
    Color(0xFF7CB5D7),
    Color(0xFF4F89A8),
    Color(0xFF1C3D5A),
    // Earth tones
    Color(0xFFD7B67C),
    Color(0xFFA88B4F),
    Color(0xFF5A421C),
    // Additional colors
    Color(0xFFD77C7C), // Red
    Color(0xFF7C7CD7), // Purple
    Color(0xFFD7D77C), // Yellow
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<FarmStateProvider>(
      builder: (context, farmState, child) {
        return Stack(
          children: [
            // Original toolbar content
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Tools',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    _buildDrawingModes(context, farmState),
                    const SizedBox(height: 16),
                    Text(
                      'Shapes',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    _buildShapeTypes(context, farmState),
                    const SizedBox(height: 16),
                    // Add color indicator
                    Row(
                      children: [
                        Text(
                          'Current Color:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _showColorPicker = !_showColorPicker;
                            });
                          },
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: farmState.selectedColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Color picker overlay
            if (_showColorPicker)
              ColorPickerOverlay(
                colors: presetColors,
                selectedColor: farmState.selectedColor,
                onColorSelected: (color) {
                  farmState.setSelectedColor(color);
                  setState(() {
                    _showColorPicker = false;
                  });
                },
                onDismiss: () {
                  setState(() {
                    _showColorPicker = false;
                  });
                },
              ),
          ],
        );
      },
    );
  }

  Widget _buildDrawingModes(BuildContext context, FarmStateProvider farmState) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: DrawingMode.values.map((mode) {
        return ChoiceChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getModeIcon(mode),
                size: 18,
              ),
              const SizedBox(width: 4),
              Text(mode.name),
            ],
          ),
          selected: farmState.currentMode == mode,
          onSelected: (selected) {
            if (selected) {
              farmState.setMode(mode);
            }
          },
        );
      }).toList(),
    );
  }

  Widget _buildShapeTypes(BuildContext context, FarmStateProvider farmState) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: ShapeType.values.map((type) {
        return ChoiceChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getShapeIcon(type),
                size: 18,
              ),
              const SizedBox(width: 4),
              Text(type.name),
            ],
          ),
          selected: farmState.selectedShapeType == type,
          onSelected: (selected) {
            if (selected) {
              farmState.setShapeType(type);
            }
          },
        );
      }).toList(),
    );
  }

  IconData _getModeIcon(DrawingMode mode) {
    switch (mode) {
      case DrawingMode.view:
        return Icons.pan_tool;
      case DrawingMode.draw:
        return Icons.draw;
      case DrawingMode.edit:
        return Icons.edit;
      case DrawingMode.delete:
        return Icons.delete;
      case DrawingMode.color:
        return Icons.color_lens;
    }
  }

  IconData _getShapeIcon(ShapeType type) {
    switch (type) {
      case ShapeType.field:
        return Icons.crop_square;
      case ShapeType.building:
        return Icons.home;
      case ShapeType.pond:
        return Icons.water;
      case ShapeType.road:
        return Icons.add_road;
    }
  }
}