import 'package:flutter/material.dart';

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
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: _goToAddTask,
          child: const Text('Add Task'),
        ),
      ),
    );
  }
}
