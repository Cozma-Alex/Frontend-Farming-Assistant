import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/providers/farm_state_provider.dart';
import '../../models/farm_element.dart';
import '../models/enums/shape_type.dart';
import '../models/enums/crop_type.dart';
import '../models/enums/location_type.dart';


class ElementListPanel extends StatelessWidget {
  const ElementListPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FarmStateProvider>(
      builder: (context, farmState, child) {
        return Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Farm Elements',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    IconButton(
                      icon: const Icon(Icons.sort),
                      onPressed: () => _showSortOptions(context),
                      tooltip: 'Sort elements',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: farmState.elements.isEmpty
                    ? _buildEmptyState()
                    : _buildElementsList(context, farmState),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.crop_square_outlined,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No elements yet',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start drawing on the map to add elements',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildElementsList(BuildContext context, FarmStateProvider farmState) {
    return ListView.builder(
      itemCount: farmState.elements.length,
      itemBuilder: (context, index) {
        final element = farmState.elements[index];
        return _buildElementTile(context, element, farmState);
      },
    );
  }

  Widget _buildElementTile(
      BuildContext context,
      FarmElement element,
      FarmStateProvider farmState,
      ) {
    return ListTile(
      leading: _getElementIcon(element),
      title: Text(element.name),
      subtitle: _buildElementSubtitle(element),
      selected: farmState.selectedElement?.id == element.id,
      onTap: () => farmState.selectElement(element),
      trailing: PopupMenuButton<String>(
        onSelected: (value) => _handleElementAction(context, value, element, farmState),
        itemBuilder: (BuildContext context) => [
          const PopupMenuItem(
            value: 'edit',
            child: Row(
              children: [
                Icon(Icons.edit),
                SizedBox(width: 8),
                Text('Edit'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'center',
            child: Row(
              children: [
                Icon(Icons.center_focus_strong),
                SizedBox(width: 8),
                Text('Center on map'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete),
                SizedBox(width: 8),
                Text('Delete'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildElementSubtitle(FarmElement element) {
    String subtitle = element.shapeType.name;

    if (element.cropType != null) {
      subtitle += ' • ${element.cropType!.displayName}';
    }
    if (element.buildingType != null) {
      subtitle += ' • ${element.buildingType!.displayName}';
    }
    if (element.animals.isNotEmpty) {
      subtitle += ' • ${element.animals.length} animals';
    }

    return Text(subtitle);
  }

  Widget _getElementIcon(FarmElement element) {
    switch (element.shapeType) {
      case ShapeType.field:
        return Icon(
          element.cropType?.icon ?? Icons.crop_square,
          color: element.color,
        );
      case ShapeType.building:
        return Icon(
          element.buildingType?.icon ?? Icons.home,
          color: element.color,
        );
      case ShapeType.pond:
        return Icon(Icons.water, color: element.color);
      case ShapeType.road:
        return Icon(Icons.add_road, color: element.color);
    }
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.sort_by_alpha),
              title: const Text('Sort by name'),
              onTap: () {
                context.read<FarmStateProvider>().sortElements('name');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Sort by date added'),
              onTap: () {
                context.read<FarmStateProvider>().sortElements('date');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text('Sort by type'),
              onTap: () {
                context.read<FarmStateProvider>().sortElements('type');
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _handleElementAction(
      BuildContext context,
      String action,
      FarmElement element,
      FarmStateProvider farmState,
      ) {
    switch (action) {
      case 'edit':
        farmState.selectElement(element);
        break;
      case 'center':
        break;
      case 'delete':
        _showDeleteConfirmation(context, element, farmState);
        break;
    }
  }

  void _showDeleteConfirmation(
      BuildContext context,
      FarmElement element,
      FarmStateProvider farmState,
      ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Element'),
          content: Text('Are you sure you want to delete "${element.name}"?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                farmState.deleteElement(element.id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}