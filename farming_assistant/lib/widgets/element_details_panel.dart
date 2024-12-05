import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/providers/farm_state_provider.dart';
import '../../models/enums/crop_type.dart';
import '../../models/enums/location_type.dart';
import '../../models/enums/animal_type.dart';
import '../../models/enums/shape_type.dart';
import '../models/farm_element.dart';

class ElementDetailsPanel extends StatelessWidget {
  const ElementDetailsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FarmStateProvider>(
      builder: (context, farmState, child) {
        final element = farmState.selectedElement;
        if (element == null) return const SizedBox.shrink();

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Element Details',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                _buildNameField(context, element, farmState),
                const SizedBox(height: 8),
                if (element.shapeType == ShapeType.field)
                  _buildCropTypeSelector(context, element, farmState),
                if (element.shapeType == ShapeType.building) ...[
                  _buildBuildingTypeSelector(context, element, farmState),
                  if (_isAnimalBuilding(element.buildingType))
                    _buildAnimalSelector(context, element, farmState),
                ],
                const SizedBox(height: 8),
                _buildNotesField(context, element, farmState),
                const SizedBox(height: 16),
                _buildLastUpdated(context, element),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNameField(
      BuildContext context,
      FarmElement element,
      FarmStateProvider farmState,
      ) {
    return TextField(
      decoration: const InputDecoration(
        labelText: 'Name',
        border: OutlineInputBorder(),
      ),
      controller: TextEditingController(text: element.name),
      onChanged: (value) {
        farmState.updateElement(element..name = value);
      },
    );
  }

  Widget _buildCropTypeSelector(
      BuildContext context,
      FarmElement element,
      FarmStateProvider farmState,
      ) {
    return DropdownButtonFormField<CropType>(
      decoration: const InputDecoration(
        labelText: 'Crop Type',
        border: OutlineInputBorder(),
      ),
      value: element.cropType ?? CropType.nothing,
      items: CropType.values.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Row(
            children: [
              Icon(type.icon),
              const SizedBox(width: 8),
              Text(type.displayName),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          farmState.updateElement(element..cropType = value);
        }
      },
    );
  }

  Widget _buildBuildingTypeSelector(
      BuildContext context,
      FarmElement element,
      FarmStateProvider farmState,
      ) {
    return DropdownButtonFormField<LocationType>(
      decoration: const InputDecoration(
        labelText: 'Building Type',
        border: OutlineInputBorder(),
      ),
      value: element.buildingType ?? LocationType.other,
      items: LocationType.values.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Row(
            children: [
              Icon(type.icon),
              const SizedBox(width: 8),
              Text(type.displayName),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          farmState.updateElement(element..buildingType = value);
        }
      },
    );
  }

  Widget _buildAnimalSelector(
      BuildContext context,
      FarmElement element,
      FarmStateProvider farmState,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'Animals',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AnimalType.values.where((type) => type != AnimalType.none).map((type) {
            return FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(type.icon, size: 18),
                  const SizedBox(width: 4),
                  Text(type.displayName),
                ],
              ),
              selected: element.animals.contains(type),
              onSelected: (selected) {
                final updatedAnimals = List<AnimalType>.from(element.animals);
                if (selected) {
                  updatedAnimals.add(type);
                } else {
                  updatedAnimals.remove(type);
                }
                farmState.updateElement(element..animals = updatedAnimals);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildNotesField(
      BuildContext context,
      FarmElement element,
      FarmStateProvider farmState,
      ) {
    return TextField(
      decoration: const InputDecoration(
        labelText: 'Notes',
        border: OutlineInputBorder(),
      ),
      maxLines: 3,
      controller: TextEditingController(text: element.notes),
      onChanged: (value) {
        farmState.updateElement(element..notes = value);
      },
    );
  }

  Widget _buildLastUpdated(BuildContext context, FarmElement element) {
    return Text(
      'Last updated: ${_formatDateTime(element.lastUpdated)}',
      style: Theme.of(context).textTheme.bodySmall,
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  bool _isAnimalBuilding(LocationType? type) {
    return type == LocationType.cowBarn ||
        type == LocationType.chickenCoop ||
        type == LocationType.pigPen;
  }
}