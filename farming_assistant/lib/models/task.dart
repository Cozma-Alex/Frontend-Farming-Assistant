import 'package:farming_assistant/models/user.dart';

import '../utils/date_time_formater.dart';
import 'enums/priority.dart';
import 'enums/recurrence.dart';
import 'enums/sections.dart';

/// Task model
/// Contains all the information about a task with the following fields:
/// - id: UUID - the unique identifier of the task
/// - name: String - the name of the task
/// - description: String - the description of the task (max 255 characters)
/// - recurrence: Recurrence - the recurrence of the task (daily, weekly, monthly, yearly)
/// - changeToMediumPriority: DateTime - the date when the task should change to medium priority
/// - changeToHighPriority: DateTime - the date when the task should change to high priority
/// - deadline: DateTime - the deadline of the task
/// - priority: Priority - the priority of the task (low, medium, high)
/// - section: Section - the section of the task
/// - done: boolean - the status of the task (done or not done)
/// - user: User - the user that the task belongs to
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
      description: jsonData['description'] ?? "",
      section:
          Section.values.byName(jsonData['section'].toString().toLowerCase()),
      priority:
          Priority.values.byName(jsonData['priority'].toString().toLowerCase()),
      recurrence: Recurrence.values
          .byName(jsonData['recurrence'].toString().toLowerCase()),
      deadline: DateTime.parse(jsonData['deadline']),
      changeToMediumPriority: DateTime.parse(jsonData['changeToMediumPriority'] ?? "0000-00-00T00:00:00.000Z"),
      changeToHighPriority: DateTime.parse(jsonData['changeToHighPriority'] ?? "0000-00-00T00:00:00.000Z"),
      user: User.fromJson(jsonData['user']),
      done: jsonData['done'] ?? false,
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
