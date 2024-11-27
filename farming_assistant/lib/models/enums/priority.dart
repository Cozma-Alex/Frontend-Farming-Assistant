enum Priority {
  low,
  medium,
  high,
}

extension SectionExtension on Priority {
  String get jsonValue {
    return this.name.toUpperCase();
  }
}
