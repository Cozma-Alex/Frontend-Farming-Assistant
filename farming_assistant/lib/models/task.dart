import 'package:farming_assistant/models/user.dart';

import 'enums/priority.dart';
import 'enums/recurrence.dart';
import 'enums/sections.dart';

class Task {
  final String id;
  final String name;
  final String description;
  final Section section;
  final Priority priority;
  final Recurrence recurrence;
  final DateTime deadline;
  final User user;

  Task({
    required this.id,
    required this.name,
    required this.description,
    required this.section,
    required this.priority,
    required this.recurrence,
    required this.deadline,
    required this.user,
  });

  static fromJson(Map <String, dynamic> jsonData) {
    return Task(
      id: jsonData['id'],
      name: jsonData['name'],
      description: jsonData['description'],
      section: Section.values[jsonData['section']],
      priority: Priority.values[jsonData['priority']],
      recurrence: Recurrence.values[jsonData['recurrence']],
      deadline: DateTime.parse(jsonData['deadline']),
      user: User.fromJson(jsonData['user']),
    );
  }

  static toJson(Task task) {
    return {
      'id': task.id,
      'name': task.name,
      'description': task.description,
      'section': task.section.toString(),
      'priority': task.priority.toString(),
      'recurrence': task.recurrence.toString(),
      'deadline': task.deadline.toString(),
      'user': User.toJson(task.user),
    };
  }

}
