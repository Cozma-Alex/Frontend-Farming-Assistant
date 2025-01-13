import 'package:farming_assistant/models/user.dart';

import '../utils/date_time_formater.dart';
import 'enums/priority.dart';
import 'enums/recurrence.dart';
import 'enums/sections.dart';

class Task {
  String? id;
  String? name;
  String? description;
  Section? section;
  Priority? priority;
  Recurrence? recurrence;
  DateTime? deadline;
  DateTime? changeToMediumPriority;
  DateTime? changeToHighPriority;
  User? user;
  bool? done;

  Task({
    this.id,
    this.name,
    this.description,
    this.section,
    this.priority,
    this.recurrence,
    this.deadline,
    this.changeToMediumPriority,
    this.changeToHighPriority,
    this.user,
    this.done,
  });

  static fromJson(Map<String, dynamic> jsonData) {
    return Task(
      id: jsonData['id'],
      name: jsonData['name'],
      description: jsonData['description'],
      section:
          Section.values.byName(jsonData['section'].toString().toLowerCase()),
      priority:
          Priority.values.byName(jsonData['priority'].toString().toLowerCase()),
      recurrence: Recurrence.values
          .byName(jsonData['recurrence'].toString().toLowerCase()),
      deadline: DateTime.parse(jsonData['deadline']),
      changeToMediumPriority: jsonData['changeToMediumPriority'] == null
          ? null
          : DateTime.parse(jsonData['changeToMediumPriority']),
      changeToHighPriority: jsonData['changeToHighPriority'] == null
          ? null
          : DateTime.parse(jsonData['changeToHighPriority']),
      user: User.fromJson(jsonData['user']),
      done: jsonData['done'],
    );
  }

  static toJson(Task task) {
    return {
      'id': task.id,
      'name': task.name,
      'description': task.description,
      'section': task.section!.jsonValue,
      'priority': task.priority!.jsonValue,
      'recurrence': task.recurrence!.jsonValue,
      'deadline': formatDateTimeString(task.deadline!),
      'changeToMediumPriority': task.changeToHighPriority == null
          ? null
          : formatDateTimeString(task.changeToMediumPriority!),
      'changeToHighPriority': task.changeToHighPriority == null
          ? null
          : formatDateTimeString(task.changeToHighPriority!),
      'user': User.toJson(task.user!),
      'done': task.done,
    };
  }

  @override
  String toString() {
    return 'Task{id: $id, name: $name, description: $description, section: $section, priority: $priority, recurrence: $recurrence, deadline: $deadline, changeToMedium: $changeToMediumPriority, changeToHigh: $changeToHighPriority, user: $user, done: $done}';
  }
}
