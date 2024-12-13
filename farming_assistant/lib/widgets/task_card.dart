import 'package:farming_assistant/APIs/task-related-apis.dart';
import 'package:farming_assistant/models/user.dart';
import 'package:flutter/material.dart';

import '../models/enums/priority.dart';
import '../models/task.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({super.key, required this.task, required this.onTaskDeleted});

  final Task task;
  final VoidCallback onTaskDeleted;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  Future<bool?> _showDeleteDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(
          color: Colors.black,
          width: 1,
        ),
      ),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          title: Text(
            widget.task.name!,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.black,
                ),
          ),
          trailing: CircleAvatar(
            backgroundColor: widget.task.priority == Priority.low
                ? Colors.green
                : widget.task.priority == Priority.medium
                    ? Colors.orange
                    : Colors.red,
            child: Text(
              widget.task.priority == Priority.low
                  ? 'L'
                  : widget.task.priority == Priority.medium
                      ? 'M'
                      : 'H',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          children: [
            const Divider(
              color: Colors.black,
              thickness: 1.5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 3,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                height: 70,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.task.description!,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.black,
                          ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Section: ${widget.task.section!.toString().split('.').last}",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.black,
                  ),
            ),
            Text(
              "Deadline: ${widget.task.deadline!.year}/"
              "${widget.task.deadline!.month}/${widget.task.deadline!.day} "
              "${widget.task.deadline!.hour}:${widget.task.deadline!.minute}",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.black,
                  ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Divider(
                color: Colors.black,
                thickness: 2,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Task newTask = widget.task;
                    newTask.done = !widget.task.done!;

                    Future<Task> updatedTask = updateTaskByIdAPI(
                      newTask,
                    );

                    updatedTask.then((value) {
                      setState(() {
                        widget.task.done = value.done;
                      });

                      if (widget.task.done!) {
                        SnackBar snackBar = const SnackBar(
                          content: Text("Task will disappear after refresh"),
                          duration: Duration(seconds: 2),
                        );

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                    overlayColor:
                        Theme.of(context).colorScheme.primaryContainer,
                  ),
                  child: Text(
                    widget.task.done! ? "Mark as not done" : "Mark as done",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.black,
                        ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Future<bool?> result = _showDeleteDialog();

                    result.then((value) {
                      if (value != null && value) {
                        deleteTaskByIdAPI(widget.task).then((_) {
                          widget.onTaskDeleted();
                        });
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                    overlayColor:
                        Theme.of(context).colorScheme.primaryContainer,
                  ),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
