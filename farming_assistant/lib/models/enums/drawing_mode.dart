enum DrawingMode {
  view,
  draw,
  edit,
  delete;

  String get name {
    switch (this) {
      case DrawingMode.view:
        return 'View';
      case DrawingMode.draw:
        return 'Draw';
      case DrawingMode.edit:
        return 'Edit';
      case DrawingMode.delete:
        return 'Delete';
    }
  }
}