import 'dart:math';

import 'package:farming_assistant/APIs/task-related-apis.dart';
import 'package:farming_assistant/models/task.dart';
import 'package:farming_assistant/models/user.dart';
import 'package:farming_assistant/providers/logged_user_provider.dart';
import 'package:farming_assistant/widgets/task_card.dart';
import 'package:farming_assistant/widgets/task_filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/enums/priority.dart';
import 'add_task_screen.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  User? loggedUser;

  void _goToAddTask() async {
    if (loggedUser == null) {
      return;
    }

    final newTask = await Navigator.of(context).push<Task>(MaterialPageRoute(
        builder: (ctx) => AddTaskScreen(loggedUser: loggedUser!)));

    if (newTask != null) {
      setState(() {
        _tasksFuture = _tasksFuture.then((tasks) {
          tasks.add(newTask);
          return tasks;
        });
      });
    }
  }

  void _refreshTasks() {
    setState(() {
      _tasksFuture = Future.delayed(Duration.zero, () {
        return getAllTasksAPI(loggedUser!);
      });
    });
  }

  late Future<List<Task>> _tasksFuture;

  Priority? _filteredPriority;

  void _changeFilteredPriority(Priority? newPriority) {
    setState(() {
      _filteredPriority = newPriority;
    });
  }

  @override
  void initState() {
    loggedUser = Provider.of<LoggedUserProvider>(context, listen: false).user;

    if (loggedUser == null) {
      setState(() {
        _tasksFuture = Future.error('Not logged in');
      });
    } else {
      setState(() {
        _tasksFuture = getAllTasksAPI(loggedUser!);
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          // remove go back button
          automaticallyImplyLeading: false,
          title: Center(
            child: Text(
              'Tasks',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      body: FutureBuilder(
        future: _tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching tasks: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final tasks = snapshot.data as List<Task>;

            List<Task> filteredTasks = tasks;

            if (_filteredPriority != null) {
              filteredTasks = filteredTasks.where((task) {
                return task.priority == _filteredPriority;
              }).toList();
            }

            return Column(
              children: [
                const SizedBox(height: 10),
                TaskFilterWidget(onPriorityChanged: _changeFilteredPriority),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      return TaskCard(
                        task: filteredTasks[index],
                        onTaskDeleted: _refreshTasks,
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: Text('No tasks found'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}
