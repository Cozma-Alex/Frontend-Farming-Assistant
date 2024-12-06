import 'package:farming_assistant/models/enums/sections.dart';
import 'package:farming_assistant/models/task.dart';
import 'package:farming_assistant/widgets/task_card.dart';
import 'package:flutter/material.dart';

import '../models/enums/priority.dart';
import 'add_task_screen.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  void _goToAddTask() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const AddTaskScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final Task task = Task(
      name: 'Task 1',
      description: "Description description long description description "
          "description long description description description description "
          "description description long description description description",
      deadline: DateTime.timestamp(),
      section: Section.animals,
      priority: Priority.low,
    );

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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TaskCard(task: task),
              TaskCard(task: task),
              TaskCard(task: task),
              TaskCard(task: task),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}
