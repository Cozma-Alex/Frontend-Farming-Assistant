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
  DateTime? changeToMedium;
  DateTime? changeToHigh;
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
     this.changeToMedium,
     this.changeToHigh,
     this.user,
     this.done,
  });


  static fromJson(Map <String, dynamic> jsonData) {
    return Task(
      id: jsonData['id'],
      name: jsonData['name'],
      description: jsonData['description'],
      section: Section.values.byName(jsonData['section'].toString().toLowerCase()),
      priority: Priority.values.byName(jsonData['priority'].toString().toLowerCase()),
      recurrence: Recurrence.values.byName(jsonData['recurrence'].toString().toLowerCase()),
      deadline: DateTime.parse(jsonData['deadline']),
      changeToMedium: DateTime.parse(jsonData['change_to_medium']),
      changeToHigh: DateTime.parse(jsonData['change_to_high']),
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
      'deadline':  formatDateTimeString(task.deadline!),
      'change_to_medium': formatDateTimeString(task.changeToMedium!),
      'change_to_high': formatDateTimeString(task.changeToHigh!),
      'user': User.toJson(task.user!),
      'done': task.done,
    };
  }

  @override
  String toString() {
    return 'Task{id: $id, name: $name, description: $description, section: $section, priority: $priority, recurrence: $recurrence, deadline: $deadline, changeToMedium: $changeToMedium, changeToHigh: $changeToHigh, user: $user, done: $done}';
  }

}
