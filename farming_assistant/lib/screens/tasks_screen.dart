import 'package:farming_assistant/APIs/task-related-apis.dart';
import 'package:farming_assistant/models/enums/sections.dart';
import 'package:farming_assistant/models/task.dart';
import 'package:farming_assistant/models/user.dart';
import 'package:farming_assistant/widgets/task_card.dart';
import 'package:farming_assistant/widgets/task_filter_widget.dart';
import 'package:flutter/material.dart';

import '../models/enums/priority.dart';
import 'add_task_screen.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  void _goToAddTask() async {
    final newTask = await Navigator.of(context)
        .push<Task>(MaterialPageRoute(builder: (ctx) => const AddTaskScreen()));

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
        return getAllTasksAPI(User(id: '0adff34b-9c96-434f-be4f-8bcbac042de6'));
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
    _tasksFuture =
        getAllTasksAPI(User(id: '0adff34b-9c96-434f-be4f-8bcbac042de6'));
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
            return const Center(
              child: Text('Error fetching tasks'),
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
