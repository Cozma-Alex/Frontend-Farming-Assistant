enum Recurrence {
  none,
  daily,
  weekly,
  monthly,
}

extension SectionExtension on Recurrence {
  String get jsonValue {
    return name.toUpperCase();
  }
}
