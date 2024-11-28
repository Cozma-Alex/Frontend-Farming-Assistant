enum LocationType {
  field,
  barn,
  storage,
  tools,
}

extension SectionExtension on LocationType {
  String get jsonValue {
    return this.name.toUpperCase();
  }
}
