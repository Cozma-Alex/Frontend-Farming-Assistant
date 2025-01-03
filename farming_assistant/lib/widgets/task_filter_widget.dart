import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../models/enums/priority.dart';

class TaskFilterWidget extends StatefulWidget {
  const TaskFilterWidget({super.key, required this.onPriorityChanged});

  final void Function(Priority?) onPriorityChanged;

  @override
  State<TaskFilterWidget> createState() => _TaskFilterWidgetState();
}

class _TaskFilterWidgetState extends State<TaskFilterWidget> {
  Priority? _selectedPriority;

  String capitalizeWord(String word) {
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: Priority.values
            .map(
              (priority) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ChoiceChip(
                  label: Text(
                    capitalizeWord(priority.name),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  selected: _selectedPriority == priority,
                  selectedColor: Colors.white,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  onSelected: (isSelected) {
                    setState(() {
                      _selectedPriority = isSelected ? priority : null;
                    });
                    widget.onPriorityChanged(_selectedPriority);
                  },
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
