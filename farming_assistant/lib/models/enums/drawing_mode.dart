/// Available drawing modes for the property map editor.
/// - view: For navigating and viewing the map
/// - draw: For adding new shapes and elements
/// - edit: For modifying existing shapes
/// - delete: For removing shapes
/// - color: For changing element colors
enum DrawingMode {
  view,
  draw,
  delete,
  color;

  String get name {
    switch (this) {
      case DrawingMode.view:
        return 'View';
      case DrawingMode.draw:
        return 'Draw';
      case DrawingMode.delete:
        return 'Delete';
      case DrawingMode.color:
        return 'Color';
    }
  }
}