import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/enums/priority.dart';
import '../models/task.dart';
import '../models/user.dart';
import '../utils/config.dart';

/// Creates a new task in the database.
///
/// Takes a [task] object to be saved. Must include user information for authorization.
/// Returns a Future containing the saved [Task] with its server-assigned ID.
///
/// Throws an Exception if:
/// * The user doesn't have permission to create tasks
/// * The API request fails
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

/// Retrieves all tasks belonging to a specific user.
///
/// Takes a [user] object for authentication and filtering.
/// Returns a Future containing a List of [Task] objects.
///
/// Throws an Exception if:
/// * The authentication fails
/// * The API request fails
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

/// Retrieves a specific task by its ID.
///
/// Takes a [task] object containing the ID to look up.
/// Returns a Future containing the requested [Task] object.
///
/// Throws an Exception if:
/// * The task ID is invalid
/// * The API request fails
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

/// Deletes a task from the database.
///
/// Takes a [task] object containing the ID to delete.
/// Returns a Future that completes when the deletion is successful.
///
/// Throws an Exception if:
/// * The API request fails
/// * The user doesn't have permission to delete this task
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

/// Updates an existing task's information.
///
/// Takes a [task] object containing the updated data and ID.
/// Returns a Future containing the updated [Task] object.
///
/// Throws an Exception if:
/// * The API request fails
/// * The user doesn't have permission to modify this task
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

/// Retrieves tasks filtered by priority level.
///
/// Takes a [user] for authentication and a [priority] level to filter by.
/// Returns a Future containing a List of filtered [Task] objects.
///
/// Throws an Exception if:
/// * The API request fails
/// * The authentication fails
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

/// Retrieves tasks filtered by completion status.
///
/// Takes a [user] for authentication and [getDoneTasks] to filter completed/incomplete tasks.
/// Returns a Future containing a List of filtered [Task] objects.
///
/// Throws an Exception if:
/// * The API request fails
/// * The authentication fails
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
