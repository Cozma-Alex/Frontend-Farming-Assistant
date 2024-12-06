import 'package:flutter/material.dart';

import '../models/enums/priority.dart';
import '../models/task.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({super.key, required this.task});

  final Task task;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
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
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                height: 70,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.task.description!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.black,
                          ),
                    ),
                  ),
                ),
              ),
            ),
            Text(
              "Section: ${widget.task.section!.toString().split('.').last}",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black,
                  ),
            ),
            Text(
              "Deadline: ${widget.task.deadline!.year}/"
              "${widget.task.deadline!.month}/${widget.task.deadline!.day} "
              "${widget.task.deadline!.hour}:${widget.task.deadline!.minute}",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                    overlayColor:
                        Theme.of(context).colorScheme.primaryContainer,
                  ),
                  child: Text(
                    'Mark as done',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.black,
                        ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
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
            )
          ],
        ),
      ),
    );
  }
}
