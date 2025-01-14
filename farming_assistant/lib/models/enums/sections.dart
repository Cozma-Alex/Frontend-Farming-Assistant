enum Section {
  crops,
  animals,
  tools,
  inventory,
  other
}

extension SectionExtension on Section {
  String get jsonValue {
    return name.toUpperCase();
  }
}
