import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../APIs/location_related_apis.dart';
import '../../main.dart';
import '../../models/coordinate.dart';
import '../../models/enums/drawing_mode.dart';
import '../../models/enums/location_type.dart';
import '../../models/farm_element.dart';
import '../../models/location.dart';
import 'logged_user_provider.dart';

class FarmStateProvider with ChangeNotifier {
  final List<FarmElement> _elements = [];
  FarmElement? _selectedElement;
  DrawingMode _currentMode = DrawingMode.view;
  LocationType? _selectedLocationType = LocationType.emptyField;
  Color _selectedColor = Colors.green;

  FarmStateProvider() {
    _loadExistingLocations();
  }

  List<FarmElement> get elements => _elements;
  FarmElement? get selectedElement => _selectedElement;
  DrawingMode get currentMode => _currentMode;
  LocationType? get selectedLocationType => _selectedLocationType;
  Color get selectedColor => _selectedColor;

  Future<void> _loadExistingLocations() async {
    try {
      final loggedUser = Provider.of<LoggedUserProvider>(navigatorKey.currentContext!, listen: false).user;
      if (loggedUser == null) return;

      final locations = await getAllLocationsOfUserAPI(loggedUser);

      _elements.clear();
      for (var location in locations) {
        _elements.add(FarmElement(
          id: location.id,
          name: location.name ?? location.type.displayName,
          type: location.type,
          points: [], // You'll need to add coordinate loading
          color: location.type.defaultColor,
        ));
      }
      notifyListeners();
    } catch (e) {
      print('Error loading locations: $e');
      // You might want to show a snackbar or handle the error differently
    }
  }

  void setMode(DrawingMode mode) {
    _currentMode = mode;
    if (mode != DrawingMode.color) {
      _selectedElement = null;
    }
    notifyListeners();
  }

  void setSelectedLocationType(LocationType type) {
    _selectedLocationType = type;
    setSelectedColor(type.defaultColor);
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
    if (_selectedElement != null && currentMode == DrawingMode.color) {
      _selectedElement!.updateColor(color);
      var index = _elements.indexWhere((e) => e.id == _selectedElement!.id);
      if (index != -1) {
        _elements[index] = _selectedElement!;
      }
      notifyListeners();
    }
  }

  Future<void> saveFarmData(BuildContext context) async {
    final loggedUser = Provider.of<LoggedUserProvider>(context, listen: false).user;
    if (loggedUser == null) return;

    if (_elements.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No elements to save')),
      );
      return;
    }

    try {
      for (var element in _elements) {
        Location location = Location(
          element.id,
          element.type,
          element.name,
          loggedUser,
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

        await saveLocationAPI(location, coordinates);
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Farm data saved successfully')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save farm data: $e')),
        );
      }
    }
  }
}