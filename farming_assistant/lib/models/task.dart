enum Section {
  crops,
  animals,
  tools,
  inventory,
  other,
}

enum Priority {
  low,
  medium,
  high,
}

enum Recurrence {
  none,
  daily,
  weekly,
  monthly,
}

class Task {
  final String id;
  final String name;
  final String description;
  final Section section;
  final Priority priority;
  final Recurrence recurrence;
  final DateTime deadline;

  Task({
    required this.id,
    required this.name,
    required this.description,
    required this.section,
    required this.priority,
    required this.recurrence,
    required this.deadline,
  });
}