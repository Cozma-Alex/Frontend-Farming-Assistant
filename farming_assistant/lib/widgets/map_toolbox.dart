import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/providers/farm_state_provider.dart';
import '../models/enums/drawing_mode.dart';
import '../models/enums/shape_type.dart';

class MapToolbox extends StatelessWidget {
  const MapToolbox({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FarmStateProvider>(
      builder: (context, farmState, child) {
        return Card(
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
              ],
            ),
          ),
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