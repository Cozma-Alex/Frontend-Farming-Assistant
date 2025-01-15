import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/enums/crop_type.dart';
import '../models/enums/drawing_mode.dart';
import '../models/enums/location_type.dart';
import '../models/enums/pond_type.dart';
import '../models/enums/road_type.dart';
import '../models/enums/shape_type.dart';
import '../models/farm_element.dart';
import '../utils/providers/farm_state_provider.dart';
import 'farm_drawing_canvas.dart';

class PropertyMapView extends StatefulWidget {
  const PropertyMapView({super.key});

  @override
  State<PropertyMapView> createState() => _PropertyMapViewState();
}

class _PropertyMapViewState extends State<PropertyMapView> {
  bool _isElementsExpanded = false;
  bool _isColorsExpanded = false;
  final TransformationController _transformationController = TransformationController();
  List<Offset> currentPoints = [];

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _onTapDown(Offset position) {
    if (Provider.of<FarmStateProvider>(context, listen: false).currentMode == DrawingMode.draw) {
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
              // Map Area
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
                    onUndo: () => setState(() => currentPoints.removeLast()),
                    onClear: () => setState(() => currentPoints.clear()),
                    onComplete: () {
                      final farmState = context.read<FarmStateProvider>();
                      FarmElement newElement = FarmElement(
                        id: DateTime.now().toString(),
                        name: 'New Element',
                        shapeType: farmState.selectedShapeType,
                        points: List.from(currentPoints),
                        color: farmState.selectedColor,
                      );
                      farmState.addElement(newElement);
                      setState(() {
                        currentPoints.clear();
                      });
                    },
                  ),
                ),
              ),

              Positioned(
                right: 16,
                bottom: 240,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FloatingActionButton(
                      heroTag: 'zoomIn',
                      mini: true,
                      onPressed: () {
                        final Matrix4 currentMatrix = _transformationController.value;
                        final Matrix4 newMatrix = currentMatrix.clone()..scale(1.2);
                        _transformationController.value = newMatrix;
                      },
                      child: const Icon(Icons.add),
                    ),
                    const SizedBox(height: 8),
                    FloatingActionButton(
                      heroTag: 'zoomOut',
                      mini: true,
                      onPressed: () {
                        final Matrix4 currentMatrix = _transformationController.value;
                        final Matrix4 newMatrix = currentMatrix.clone()..scale(0.8);
                        _transformationController.value = newMatrix;
                      },
                      child: const Icon(Icons.remove),
                    ),
                    const SizedBox(height: 8),
                    if (farmState.currentMode == DrawingMode.draw)
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check),
                            onPressed: currentPoints.length >= 3 ? () {
                              final farmState = context.read<FarmStateProvider>();
                              FarmElement newElement = FarmElement(
                                id: DateTime.now().toString(),
                                name: 'New Element',
                                shapeType: farmState.selectedShapeType,
                                points: List.from(currentPoints),
                                color: farmState.selectedColor,
                              );
                              farmState.addElement(newElement);
                              setState(() {
                                currentPoints.clear();
                              });
                            } : null,
                          ),
                          IconButton(
                            icon: const Icon(Icons.undo),
                            onPressed: currentPoints.isNotEmpty ? () {
                              setState(() {
                                currentPoints.removeLast();
                              });
                            } : null,
                          ),
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: currentPoints.isNotEmpty ? () {
                              setState(() {
                                currentPoints.clear();
                              });
                            } : null,
                          ),
                        ],
                      ),
                  ],
                ),
              ),

              // Bottom Tools Panel
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Shape Types with Subtypes
                      Column(
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: SegmentedButton<ShapeType>(
                              segments: const [
                                ButtonSegment(
                                  value: ShapeType.field,
                                  icon: Icon(Icons.crop_square),
                                  label: Text('Field'),
                                ),
                                ButtonSegment(
                                  value: ShapeType.building,
                                  icon: Icon(Icons.home),
                                  label: Text('Building'),
                                ),
                                ButtonSegment(
                                  value: ShapeType.pond,
                                  icon: Icon(Icons.water),
                                  label: Text('Pond'),
                                ),
                                ButtonSegment(
                                  value: ShapeType.road,
                                  icon: Icon(Icons.add_road),
                                  label: Text('Road'),
                                ),
                              ],
                              selected: {farmState.selectedShapeType},
                              onSelectionChanged: (Set<ShapeType> selection) {
                                if (selection.isNotEmpty) {
                                  farmState.setShapeType(selection.first);
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: _buildSubTypeDropdown(farmState),
                          ),
                        ],
                      ),

                      // Drawing Tools
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildToolButton(
                              context: context,
                              icon: Icons.pan_tool,
                              label: 'View',
                              isSelected: farmState.currentMode == DrawingMode.view,
                              onPressed: () => farmState.setMode(DrawingMode.view),
                            ),
                            _buildToolButton(
                              context: context,
                              icon: Icons.edit,
                              label: 'Draw',
                              isSelected: farmState.currentMode == DrawingMode.draw,
                              onPressed: () => farmState.setMode(DrawingMode.draw),
                            ),
                            _buildToolButton(
                              context: context,
                              icon: Icons.crop_square,
                              label: 'Edit',
                              isSelected: farmState.currentMode == DrawingMode.edit,
                              onPressed: () => farmState.setMode(DrawingMode.edit),
                            ),
                            _buildToolButton(
                              context: context,
                              icon: Icons.delete,
                              label: 'Delete',
                              isSelected: farmState.currentMode == DrawingMode.delete,
                              onPressed: () => farmState.setMode(DrawingMode.delete),
                            ),
                            _buildToolButton(
                              context: context,
                              icon: Icons.color_lens,
                              label: 'Colors',
                              isSelected: _isColorsExpanded,
                              onPressed: () => setState(() {
                                _isColorsExpanded = !_isColorsExpanded;
                                if (_isColorsExpanded) _isElementsExpanded = false;
                              }),
                            ),
                            _buildToolButton(
                              context: context,
                              icon: Icons.list,
                              label: 'Elements',
                              isSelected: _isElementsExpanded,
                              onPressed: () => setState(() {
                                _isElementsExpanded = !_isElementsExpanded;
                                if (_isElementsExpanded) _isColorsExpanded = false;
                              }),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),

            // Expandable panels for Colors and Elements
              if (_isColorsExpanded)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 120,
                  child: Container(
                    color: Theme.of(context).colorScheme.surface,
                    padding: const EdgeInsets.all(16),
                    child: _buildColorPicker(farmState),
                  ),
                ),
              if (_isElementsExpanded)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 120,
                  child: Container(
                    height: 200,
                    color: Theme.of(context).colorScheme.surface,
                    padding: const EdgeInsets.all(16),
                    child: _buildElementsList(farmState),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

Widget _buildSubTypeDropdown(FarmStateProvider farmState) {
  switch (farmState.selectedShapeType) {
    case ShapeType.field:
      return DropdownButtonFormField<CropType>(
        value: farmState.selectedCropType ?? CropType.nothing,
        decoration: const InputDecoration(
          labelText: 'Crop Type',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        items: CropType.values.map((type) => DropdownMenuItem(
          value: type,
          child: Row(
            children: [
              Icon(type.icon, size: 20),
              const SizedBox(width: 8),
              Text(type.displayName),
            ],
          ),
        )).toList(),
        onChanged: (value) => farmState.setSelectedCropType(value!),
      );

    case ShapeType.building:
      return DropdownButtonFormField<LocationType>(
        value: farmState.selectedLocationType ?? LocationType.other,
        decoration: const InputDecoration(
          labelText: 'Building Type',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        items: LocationType.values.map((type) => DropdownMenuItem(
          value: type,
          child: Row(
            children: [
              Icon(type.icon, size: 20),
              const SizedBox(width: 8),
              Text(type.displayName),
            ],
          ),
        )).toList(),
        onChanged: (value) => farmState.setSelectedLocationType(value!),
      );

    case ShapeType.pond:
      return DropdownButtonFormField<PondType>(
        value: farmState.selectedPondType ?? PondType.irrigation,
        decoration: const InputDecoration(
          labelText: 'Pond Type',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        items: PondType.values.map((type) => DropdownMenuItem(
          value: type,
          child: Row(
            children: [
              Icon(type.icon, size: 20),
              const SizedBox(width: 8),
              Text(type.displayName),
            ],
          ),
        )).toList(),
        onChanged: (value) => farmState.setSelectedPondType(value!),
      );

    case ShapeType.road:
      return DropdownButtonFormField<RoadType>(
        value: farmState.selectedRoadType ?? RoadType.accessPath,
        decoration: const InputDecoration(
          labelText: 'Road Type',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        items: RoadType.values.map((type) => DropdownMenuItem(
          value: type,
          child: Row(
            children: [
              Icon(type.icon, size: 20),
              const SizedBox(width: 8),
              Text(type.displayName),
            ],
          ),
        )).toList(),
        onChanged: (value) => farmState.setSelectedRoadType(value!),
      );
  }
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

Widget _buildColorPicker(FarmStateProvider farmState) {
  final colors = [
    const Color(0xFFA7D77C),
    const Color(0xFF69A84F),
    const Color(0xFF2E5A1C),
    const Color(0xFF7CB5D7),
    const Color(0xFF4F89A8),
    const Color(0xFF1C3D5A),
    const Color(0xFFD7B67C),
    const Color(0xFFA88B4F),
    const Color(0xFF5A421C),
    const Color(0xFFD77C7C),
    const Color(0xFF7C7CD7),
    const Color(0xFFD7D77C),
    const Color(0xFFFFFFFF),
  ];


  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: colors.length + 1, // +1 for "No Color" option
        itemBuilder: (context, index) {
          if (index == colors.length) {
            return InkWell(
              onTap: () {
                if (farmState.currentMode == DrawingMode.edit && farmState.selectedElement != null) {
                  switch (farmState.selectedElement!.shapeType) {
                    case ShapeType.field:
                      farmState.setSelectedColor(farmState.selectedCropType?.defaultColor ?? colors[0]);
                      break;
                    case ShapeType.building:
                      farmState.setSelectedColor(farmState.selectedLocationType?.defaultColor ?? colors[0]);
                      break;
                    case ShapeType.pond:
                      farmState.setSelectedColor(farmState.selectedPondType?.defaultColor ?? colors[0]);
                      break;
                    case ShapeType.road:
                      farmState.setSelectedColor(farmState.selectedRoadType?.defaultColor ?? colors[0]);
                      break;
                  }
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey),
                ),
                child: const Center(
                  child: Icon(Icons.not_interested),
                ),
              ),
            );
          }
          final color = colors[index];
          return InkWell(
            onTap: () => farmState.setSelectedColor(color),
            child: Container(
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: farmState.selectedColor == color
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
          );
        },
      ),
    ],
  );
}

Widget _buildElementsList(FarmStateProvider farmState) {
  return ListView.builder(
    itemCount: farmState.elements.length,
    itemBuilder: (context, index) {
      final element = farmState.elements[index];
      return Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          title: Text(element.name),
          selected: farmState.selectedElement?.id == element.id,
          leading: Icon(
            _getElementIcon(element.shapeType),
            color: element.color,
          ),
          trailing: PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Text('Edit'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete'),
              ),
            ],
            onSelected: (value) {
              if (value == 'delete') {
                farmState.deleteElement(element.id);
              } else if (value == 'edit') {
                farmState.selectElement(element);
              }
            },
          ),
          onTap: () => farmState.selectElement(element),
        ),
      );
    },
  );
}

IconData _getElementIcon(ShapeType type) {
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
          _buildLegendItem(context, Icons.pan_tool, 'View - Navigate the map'),
          _buildLegendItem(context, Icons.edit, 'Draw - Add new elements'),
          _buildLegendItem(
              context, Icons.crop_square, 'Edit - Modify elements'),
          _buildLegendItem(context, Icons.delete, 'Delete - Remove elements'),
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
