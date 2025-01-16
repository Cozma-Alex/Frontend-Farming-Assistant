/// The TaskPriority enum is used to define the priority of a task.
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
