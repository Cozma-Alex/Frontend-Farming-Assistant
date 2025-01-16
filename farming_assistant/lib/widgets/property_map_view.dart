import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/enums/drawing_mode.dart';
import '../models/enums/location_type.dart';
import '../models/farm_element.dart';
import '../utils/providers/farm_state_provider.dart';
import 'farm_drawing_canvas.dart';
import 'package:uuid/uuid.dart';

class PropertyMapView extends StatefulWidget {
  const PropertyMapView({super.key});

  @override
  State<PropertyMapView> createState() => _PropertyMapViewState();
}

class _PropertyMapViewState extends State<PropertyMapView> {
  final TransformationController _transformationController =
      TransformationController();
  List<Offset> currentPoints = [];
  final _uuid = const Uuid();
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
    Color(0xFFFFFFFF), // White
  ];

  bool _showColorPicker = false;

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _onTapDown(Offset position) {
    if (Provider.of<FarmStateProvider>(context, listen: false).currentMode ==
        DrawingMode.draw) {
      setState(() {
        currentPoints.add(position);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FarmStateProvider>(
      builder: (context, farmState, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Map View'),
            actions: [
              FilledButton.icon(
                onPressed: () => farmState.saveFarmData(context),
                icon: const Icon(Icons.save, size: 20),
                label: const Text('Save'),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.help_outline),
                onPressed: () => _showLegend(context),
                tooltip: 'Show Legend',
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        InteractiveViewer(
                          transformationController: _transformationController,
                          minScale: 0.1,
                          maxScale: 4.0,
                          boundaryMargin: const EdgeInsets.all(double.infinity),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFFCEB08A),
                            ),
                            child: FarmDrawingCanvas(
                              currentPoints: currentPoints,
                              onTapDown: _onTapDown,
                              onUndo: () =>
                                  setState(() => currentPoints.removeLast()),
                              onClear: () =>
                                  setState(() => currentPoints.clear()),
                              onComplete: () {
                                final farmState =
                                    context.read<FarmStateProvider>();
                                FarmElement newElement = FarmElement(
                                  id: _uuid.v4(),
                                  name: 'New Element',
                                  type: farmState.selectedLocationType ??
                                      LocationType.emptyField,
                                  points: List.from(currentPoints),
                                  color: farmState.selectedColor,
                                );
                                farmState.addElement(newElement);
                                setState(() {
                                  currentPoints.clear();
                                });
                              },
                              transformationController:
                                  _transformationController,
                            ),
                          ),
                        ),
// Fixed position controls overlay
                        MapControlsOverlay(
                          farmState: farmState,
                          currentPoints: currentPoints,
                          onZoomIn: () {
                            final Matrix4 currentMatrix =
                                _transformationController.value;
                            final Matrix4 newMatrix = currentMatrix.clone()
                              ..scale(1.2);
                            _transformationController.value = newMatrix;
                          },
                          onZoomOut: () {
                            final Matrix4 currentMatrix =
                                _transformationController.value;
                            final Matrix4 newMatrix = currentMatrix.clone()
                              ..scale(0.8);
                            _transformationController.value = newMatrix;
                          },
                          onUndo: () =>
                              setState(() => currentPoints.removeLast()),
                          onClear: () => setState(() => currentPoints.clear()),
                          onComplete: () {
                            if (currentPoints.length >= 3) {
                              final farmState =
                                  context.read<FarmStateProvider>();
                              FarmElement newElement = FarmElement(
                                id: _uuid.v4(),
                                name: 'New Element',
                                type: farmState.selectedLocationType ??
                                    LocationType.emptyField,
                                points: List.from(currentPoints),
                                color: farmState.selectedColor,
                              );
                              farmState.addElement(newElement);
                              setState(() {
                                currentPoints.clear();
                              });
                            }
                          },
                        ),
                        if (farmState.currentMode == DrawingMode.color)
                          Positioned(
                            right: 80,
                            top: 80,
                            child: ColorPickerOverlay(
                              colors: presetColors,
                              selectedColor: farmState.selectedColor,
                              onColorSelected: (color) {
                                farmState.setSelectedColor(color);
                                if (farmState.selectedElement != null) {
                                  FarmElement updatedElement = FarmElement(
                                    id: farmState.selectedElement!.id,
                                    name: farmState.selectedElement!.name,
                                    type: farmState.selectedElement!.type,
                                    points: farmState.selectedElement!.points,
                                    color: color,
                                  );
                                  farmState.updateElement(updatedElement);
                                }
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
// Bottom Toolbox
                  Container(
                    color: Theme.of(context).colorScheme.surface,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: SegmentedButton<String>(
                            segments: const [
                              ButtonSegment(
                                value: 'field',
                                icon: Icon(Icons.crop_square),
                                label: Text('Field'),
                              ),
                              ButtonSegment(
                                value: 'building',
                                icon: Icon(Icons.home),
                                label: Text('Building'),
                              ),
                              ButtonSegment(
                                value: 'pond',
                                icon: Icon(Icons.water),
                                label: Text('Pond'),
                              ),
                              ButtonSegment(
                                value: 'road',
                                icon: Icon(Icons.add_road),
                                label: Text('Road'),
                              ),
                            ],
                            selected: {
                              _getSelectedCategory(
                                  farmState.selectedLocationType)
                            },
                            onSelectionChanged: (Set<String> selection) {
                              if (selection.isNotEmpty) {
                                LocationType newType;
                                switch (selection.first) {
                                  case 'field':
                                    newType = LocationType.emptyField;
                                    break;
                                  case 'building':
                                    newType = LocationType.house;
                                    break;
                                  case 'pond':
                                    newType = LocationType.fishingPond;
                                    break;
                                  case 'road':
                                    newType = LocationType.mainRoad;
                                    break;
                                  default:
                                    newType = LocationType.emptyField;
                                }
                                farmState.setSelectedLocationType(newType);
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _buildSubTypeDropdown(farmState),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildToolButton(
                                context: context,
                                icon: Icons.pan_tool,
                                label: 'View',
                                isSelected:
                                    farmState.currentMode == DrawingMode.view,
                                onPressed: () =>
                                    farmState.setMode(DrawingMode.view),
                              ),
                              _buildToolButton(
                                context: context,
                                icon: Icons.edit,
                                label: 'Draw',
                                isSelected:
                                    farmState.currentMode == DrawingMode.draw,
                                onPressed: () =>
                                    farmState.setMode(DrawingMode.draw),
                              ),
                              _buildToolButton(
                                context: context,
                                icon: Icons.delete,
                                label: 'Delete',
                                isSelected:
                                    farmState.currentMode == DrawingMode.delete,
                                onPressed: () =>
                                    farmState.setMode(DrawingMode.delete),
                              ),
                              _buildToolButton(
                                context: context,
                                icon: Icons.color_lens,
                                label: 'Color',
                                isSelected:
                                    farmState.currentMode == DrawingMode.color,
                                onPressed: () =>
                                    farmState.setMode(DrawingMode.color),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _getSelectedCategory(LocationType? type) {
    if (type == null) return 'field';
    if (type.isField) return 'field';
    if (type.isBuilding) return 'building';
    if (type.isPond) return 'pond';
    if (type.isRoad) return 'road';
    return 'field';
  }

  Widget _buildToolButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon),
          style: IconButton.styleFrom(
            backgroundColor: isSelected
                ? Theme.of(context).colorScheme.primaryContainer
                : Colors.transparent,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }

  void _showLegend(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Map Legend',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLegendItem(
                context, Icons.crop_square, 'Field - For crops and pastures'),
            _buildLegendItem(context, Icons.home, 'Building - Farm structures'),
            _buildLegendItem(context, Icons.water, 'Pond - Water bodies'),
            _buildLegendItem(context, Icons.add_road, 'Road - Access paths'),
            const Divider(height: 24),
            _buildLegendItem(
                context, Icons.pan_tool, 'View - Navigate the map'),
            _buildLegendItem(context, Icons.edit, 'Draw - Add new elements'),
            _buildLegendItem(
                context, Icons.crop_square, 'Edit - Modify elements'),
            _buildLegendItem(context, Icons.delete, 'Delete - Remove elements'),
            _buildLegendItem(
                context, Icons.color_lens, 'Color - Change element color'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubTypeDropdown(FarmStateProvider farmState) {
    List<LocationType> getRelevantTypes() {
      if (farmState.selectedLocationType == null) return [];

      if (farmState.selectedLocationType!.isField) {
        return LocationType.values.where((t) => t.isField).toList();
      }
      if (farmState.selectedLocationType!.isBuilding) {
        return LocationType.values.where((t) => t.isBuilding).toList();
      }
      if (farmState.selectedLocationType!.isPond) {
        return LocationType.values.where((t) => t.isPond).toList();
      }
      if (farmState.selectedLocationType!.isRoad) {
        return LocationType.values.where((t) => t.isRoad).toList();
      }
      return [LocationType.emptyField];
    }

    return DropdownButtonFormField<LocationType>(
      value: farmState.selectedLocationType,
      decoration: const InputDecoration(
        labelText: 'Type',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: getRelevantTypes()
          .map((type) => DropdownMenuItem(
                value: type,
                child: Row(
                  children: [
                    Icon(type.icon, size: 20),
                    const SizedBox(width: 8),
                    Text(type.displayName),
                  ],
                ),
              ))
          .toList(),
      onChanged: (value) {
        if (value != null) {
          farmState.setSelectedLocationType(value);
        }
      },
    );
  }
}

class ColorPickerOverlay extends StatelessWidget {
  final List<Color> colors;
  final Color selectedColor;
  final Function(Color) onColorSelected;

  const ColorPickerOverlay({
    super.key,
    required this.colors,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Container(
        padding: const EdgeInsets.all(12),
        width: 200,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Color',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: colors.map((color) {
                return GestureDetector(
                  onTap: () => onColorSelected(color),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selectedColor == color
                            ? Colors.black
                            : Colors.grey.shade300,
                        width: selectedColor == color ? 2 : 1,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
