import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../APIs/location_related_apis.dart';
import '../../models/coordinate.dart';
import '../../models/enums/crop_type.dart';
import '../../models/enums/drawing_mode.dart';
import '../../models/enums/location_type.dart';
import '../../models/enums/pond_type.dart';
import '../../models/enums/road_type.dart';
import '../../models/enums/shape_type.dart';
import '../../models/farm_element.dart';
import '../../models/location.dart';
import 'logged_user_provider.dart';
import '../../widgets/property_map_view.dart';

class FarmStateProvider with ChangeNotifier {
  final List<FarmElement> _elements = [];
  FarmElement? _selectedElement;
  DrawingMode _currentMode = DrawingMode.view;
  ShapeType _selectedShapeType = ShapeType.field;
  Color _selectedColor = Colors.green;
  CropType? selectedCropType;
  LocationType? selectedLocationType;
  PondType? selectedPondType;
  RoadType? selectedRoadType;

  List<FarmElement> get elements => _elements;
  FarmElement? get selectedElement => _selectedElement;
  DrawingMode get currentMode => _currentMode;
  ShapeType get selectedShapeType => _selectedShapeType;
  Color get selectedColor => _selectedColor;

  Future<void> saveFarmData(BuildContext context) async {
    List<Map<String, dynamic>> locationsWithCoordinates = [];

    for (var element in _elements) {
      try {
        LocationType locationType = _mapElementToLocationType(element);
        Location location = Location(
          element.id,
          locationType,
          _getElementName(element),
          Provider.of<LoggedUserProvider>(context, listen: false).user!,
        );

        List<Coordinate> coordinates = element.points.asMap().entries.map((entry) {
          return Coordinate(
            '',
            entry.value.dx,
            entry.value.dy,
            entry.key,
            location,
          );
        }).toList();

        locationsWithCoordinates.add({
          'location': location,
          'coordinates': coordinates,
        });
      } catch (e) {
        debugPrint('Error converting element to location: $e');
      }
    }

    if (locationsWithCoordinates.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No valid locations to save')),
      );
      return;
    }

    try {
      for (var locationData in locationsWithCoordinates) {
        await saveLocationAPI(
          locationData['location'] as Location,
          locationData['coordinates'] as List<Coordinate>,
        );
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Locations saved successfully')),
      );

      // Refresh map after saving
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (_) => FarmStateProvider(),
            child: const PropertyMapView(),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save locations: $e')),
      );
    }
  }

  void setMode(DrawingMode mode) {
    _currentMode = mode;
    notifyListeners();
  }

  void setShapeType(ShapeType type) {
    _selectedShapeType = type;
    notifyListeners();
  }

  void selectElement(FarmElement? element) {
    _selectedElement = element;
    notifyListeners();
  }

  void addElement(FarmElement element) {
    element.color = _selectedColor;
    _elements.add(element);
    notifyListeners();
  }

  void updateElement(FarmElement element) {
    final index = _elements.indexWhere((e) => e.id == element.id);
    if (index != -1) {
      _elements[index] = element;
      notifyListeners();
    }
  }

  void deleteElement(String id) {
    _elements.removeWhere((e) => e.id == id);
    if (_selectedElement?.id == id) {
      _selectedElement = null;
    }
    notifyListeners();
  }

  void setSelectedColor(Color color) {
    _selectedColor = color;
    if (_selectedElement != null && currentMode == DrawingMode.edit) {
      _selectedElement!.updateColor(color);
      var index = _elements.indexWhere((e) => e.id == _selectedElement!.id);
      if (index != -1) {
        _elements[index] = _selectedElement!;
      }
      notifyListeners();
    }
  }

  LocationType _mapElementToLocationType(FarmElement element) {
    switch (element.shapeType) {
      case ShapeType.building:
        return element.buildingType ?? LocationType.other;

      case ShapeType.field:
        if (element.cropType == null) return LocationType.emptyField;
        switch (element.cropType) {
          case CropType.grass:
            return LocationType.grassField;
          case CropType.wheat:
            return LocationType.wheatField;
          case CropType.corn:
            return LocationType.cornField;
          case CropType.soybeans:
            return LocationType.soybeansField;
          case CropType.potatoes:
            return LocationType.potatoesField;
          case CropType.vegetables:
            return LocationType.vegetablesField;
          case CropType.nothing:
            return LocationType.emptyField;
          default:
            return LocationType.emptyField;
        }

      case ShapeType.pond:
        if (element.pondType == null) return LocationType.naturalPond;
        switch (element.pondType) {
          case PondType.fishing:
            return LocationType.fishingPond;
          case PondType.irrigation:
            return LocationType.irrigationPond;
          case PondType.decorative:
            return LocationType.decorativePond;
          case PondType.natural:
            return LocationType.naturalPond;
          default:
            return LocationType.naturalPond;
        }

      case ShapeType.road:
        if (element.roadType == null) return LocationType.accessPath;
        switch (element.roadType) {
          case RoadType.mainRoad:
            return LocationType.mainRoad;
          case RoadType.accessPath:
            return LocationType.accessPath;
          case RoadType.farmTrack:
            return LocationType.farmTrack;
          case RoadType.serviceRoad:
            return LocationType.serviceRoad;
          default:
            return LocationType.accessPath;
        }
    }
  }

  void sortElements(String criteria) {
    switch (criteria) {
      case 'name':
        _elements.sort((a, b) => a.name.compareTo(b.name));
      case 'date':
        _elements.sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));
      case 'type':
        _elements.sort((a, b) {
          int typeCompare = a.shapeType.name.compareTo(b.shapeType.name);
          return typeCompare != 0 ? typeCompare : a.name.compareTo(b.name);
        });
    }
    notifyListeners();
  }

  void setSelectedCropType(CropType type) {
    selectedCropType = type;
    setSelectedColor(type.defaultColor);
    notifyListeners();
  }

  void setSelectedLocationType(LocationType type) {
    selectedLocationType = type;
    setSelectedColor(type.defaultColor);
    notifyListeners();
  }

  void setSelectedPondType(PondType type) {
    selectedPondType = type;
    setSelectedColor(type.defaultColor);
    notifyListeners();
  }

  void setSelectedRoadType(RoadType type) {
    selectedRoadType = type;
    setSelectedColor(type.defaultColor);
    notifyListeners();
  }

  String _getElementName(FarmElement element) {
    switch (element.shapeType) {
      case ShapeType.field:
        return element.cropType?.displayName ?? 'Empty Field';

      case ShapeType.building:
        if (element.buildingType != null) {
          return element.buildingType?.displayName ?? 'Building';
        }
        return 'Building';

      case ShapeType.pond:
        if (element.pondType != null) {
          return element.pondType?.displayName ?? 'Pond';
        }
        return 'Pond';

      case ShapeType.road:
        if (element.roadType != null) {
          return element.roadType?.displayName ?? 'Road';
        }
        return 'Road';
    }
  }

}