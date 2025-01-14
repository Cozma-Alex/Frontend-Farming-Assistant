enum Priority {
  low,
  medium,
  high,
}

extension SectionExtension on Priority {
  String get jsonValue {
    return name.toUpperCase();
  }
}
