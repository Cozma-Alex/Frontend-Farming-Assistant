import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/enums/drawing_mode.dart';
import '../models/enums/location_type.dart';
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

  Widget _buildSubTypeDropdown(FarmStateProvider farmState) {
    List<LocationType> getRelevantTypes(LocationType? currentType) {
      if (currentType == null) return [];

      if (currentType.isField) {
        return LocationType.values.where((t) => t.isField).toList();
      }
      if (currentType.isBuilding) {
        return LocationType.values.where((t) => t.isBuilding).toList();
      }
      if (currentType.isPond) {
        return LocationType.values.where((t) => t.isPond).toList();
      }
      if (currentType.isRoad) {
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
      items: getRelevantTypes(farmState.selectedLocationType).map((type) => DropdownMenuItem(
        value: type,
        child: Row(
          children: [
            Icon(type.icon, size: 20),
            const SizedBox(width: 8),
            Text(type.displayName),
          ],
        ),
      )).toList(),
      onChanged: (value) {
        if (value != null) {
          farmState.setSelectedLocationType(value);
        }
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

  Widget _buildElementsList(FarmStateProvider farmState) {
    return ListView.builder(
      itemCount: farmState.elements.length,
      itemBuilder: (context, index) {
        final element = farmState.elements[index];
        return Card(
          child: ListTile(
            leading: Icon(element.type.icon, color: element.color),
            title: Text(element.name),
            subtitle: Text(element.type.displayName),
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
                switch (value) {
                  case 'edit':
                    farmState.selectElement(element);
                    break;
                  case 'delete':
                    farmState.deleteElement(element.id);
                    break;
                }
              },
            ),
            selected: farmState.selectedElement?.id == element.id,
            onTap: () => farmState.selectElement(element),
          ),
        );
      },
    );
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
            ],
          ),
          body: Stack(
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
                    onUndo: () => setState(() => currentPoints.removeLast()),
                    onClear: () => setState(() => currentPoints.clear()),
                    onComplete: () {
                      if (farmState.selectedLocationType != null) {
                        final newElement = FarmElement(
                          id: DateTime.now().toString(),
                          name: 'New Element',
                          type: farmState.selectedLocationType!,
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
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                          selected: {_getSelectedCategory(farmState.selectedLocationType)},
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
                        padding: const EdgeInsets.all(16),
                        child: _buildSubTypeDropdown(farmState),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
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
                              icon: Icons.edit_note,
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
                          ],
                        ),
                      ),
                    ],
                  ),
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