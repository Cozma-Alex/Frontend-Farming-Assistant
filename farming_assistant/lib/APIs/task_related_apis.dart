import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/enums/priority.dart';
import '../models/task.dart';
import '../models/user.dart';
import '../utils/config.dart';

Future<Task> saveTaskAPI(Task task) async {
  final uri = Uri.parse('${APIConfig.baseURI}/tasks');

  try {
    final response = await http.post(uri,
        headers: {
          'Authorization': task.user!.id!,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(Task.toJson(task)));

    return Task.fromJson(jsonDecode(response.body));
  } catch (e) {
    throw Exception('Failed to login: $e');
  }
}

Future<List<Task>> getAllTasksAPI(User user) async {
  final uri = Uri.parse('${APIConfig.baseURI}/tasks');

  try {
    final response = await http.get(
      uri,
      headers: {
        'Authorization': user.id!,
        'Content-Type': 'application/json',
      },
    );

    return List<Task>.from(
        jsonDecode(response.body).map((e) => Task.fromJson(e)).toList());
  } catch (e) {
    throw Exception('Failed to login: $e');
  }
}

Future<Task> getTaskByIdAPI(Task task) async {
  final uri = Uri.parse('${APIConfig.baseURI}/tasks/${task.id}');

  try {
    final response = await http.get(
      uri,
      headers: {
        'Authorization': task.user!.id!,
        'Content-Type': 'application/json',
      },
    );

    return Task.fromJson(jsonDecode(response.body));
  } catch (e) {
    throw Exception('Failed to login: $e');
  }
}

Future<void> deleteTaskByIdAPI(Task task) async {
  final uri = Uri.parse('${APIConfig.baseURI}/tasks/${task.id}');

  try {
    await http.delete(
      uri,
      headers: {
        'Authorization': task.user!.id!,
        'Content-Type': 'application/json',
      },
    );
  } catch (e) {
    throw Exception('Failed to login: $e');
  }
}

Future<Task> updateTaskByIdAPI(Task task) async {
  final uri = Uri.parse('${APIConfig.baseURI}/tasks/${task.id}');

  try {
    final response = await http.put(uri,
        headers: {
          'Authorization': task.user!.id!,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(Task.toJson(task)));

    return Task.fromJson(jsonDecode(response.body));
  } catch (e) {
    throw Exception('Failed to login: $e');
  }
}

Future<List<Task>> getTasksByPriorityAPI(User user, Priority priority) async {
  final uri = Uri.parse(
      '${APIConfig.baseURI}/tasks/filters/priority/${priority.jsonValue}');

  try {
    final response = await http.get(
      uri,
      headers: {
        'Authorization': user.id!,
        'Content-Type': 'application/json',
      },
    );

    return List.of(jsonDecode(response.body).map((e) => Task.fromJson(e)));
  } catch (e) {
    throw Exception('Failed to login: $e');
  }
}

Future<List<Task>> getTasksDoneAPI(User user, bool getDoneTasks) async {
  final uri =
      Uri.parse('${APIConfig.baseURI}/tasks/filters/done/$getDoneTasks');

  try {
    final response = await http.get(
      uri,
      headers: {
        'Authorization': user.id!,
        'Content-Type': 'application/json',
      },
    );

    return List.of(jsonDecode(response.body).map((e) => Task.fromJson(e)));
  } catch (e) {
    throw Exception('Failed to login: $e');
  }
}
