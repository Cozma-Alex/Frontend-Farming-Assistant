import 'package:flutter/material.dart';
import '../../models/farm_element.dart';
import '../../models/enums/drawing_mode.dart';
import '../../models/enums/shape_type.dart';

class FarmStateProvider with ChangeNotifier {
  final List<FarmElement> _elements = [];
  FarmElement? _selectedElement;
  DrawingMode _currentMode = DrawingMode.view;
  ShapeType _selectedShapeType = ShapeType.field;

  List<FarmElement> get elements => _elements;
  FarmElement? get selectedElement => _selectedElement;
  DrawingMode get currentMode => _currentMode;
  ShapeType get selectedShapeType => _selectedShapeType;

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

  // Placeholder for future save implementation
  void saveFarmData() {
    // Will be implemented later with SQLite and server sync
    print('Save functionality will be implemented with SQLite and server sync');
  }

  void sortElements(String criteria) {
    switch (criteria) {
      case 'name':
        _elements.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'date':
        _elements.sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));
        break;
      case 'type':
        _elements.sort((a, b) {
          int typeCompare = a.shapeType.name.compareTo(b.shapeType.name);
          if (typeCompare != 0) return typeCompare;
          return a.name.compareTo(b.name);
        });
        break;
    }
    notifyListeners();
  }

  final List<List<Offset>> _strokes = [];

  List<List<Offset>> get strokes => _strokes;

  void addStroke(List<Offset> stroke) {
    _strokes.add(stroke);
    notifyListeners();
  }

  void undoStroke() {
    if (_strokes.isNotEmpty) {
      _strokes.removeLast();
      notifyListeners();
    }
  }

  void clearStrokes() {
    _strokes.clear();
    notifyListeners();
  }

}