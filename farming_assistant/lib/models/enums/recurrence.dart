/// Enum for task recurrence options
enum Recurrence {
  none,
  daily,
  weekly,
  monthly,
}

extension SectionExtension on Recurrence {
  String get jsonValue {
    return this.name.toUpperCase();
  }
}
