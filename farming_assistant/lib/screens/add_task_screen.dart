import 'package:flutter/material.dart';

import '../APIs/task-related-apis.dart';
import '../models/enums/priority.dart';
import '../models/enums/recurrence.dart';
import '../models/enums/sections.dart';
import '../models/task.dart';
import '../models/user.dart';

/// A screen for adding a new task.
/// Upon completing all the necessary form fields correctly and pressing the save button,
/// a call to the backend is made to save the task, and the user is navigated
/// back to the [TasksScreen].
/// The context pops the new task to the [TasksScreen] to update the list of
/// tasks without the need for another call to the backend.
class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key, required this.loggedUser});

  final User loggedUser;

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDescriptionController =
      TextEditingController();

  Section? _selectedSection;

  Recurrence _selectedRecurrence = Recurrence.none;

  void _selectRecurrence(Recurrence? recurrence) {
    setState(() {
      _selectedRecurrence = recurrence!;
    });
  }

  DateTime? _changeToMediumPriorityDate;
  DateTime? _changeToHighPriorityDate;

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  Future<DateTime?> _openSelectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 760)),
    );

    return picked;
  }

  Future<void>? _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.navigate_before),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 60),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.black54,
                width: 1,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  spreadRadius: 3,
                  blurRadius: 3,
                  offset: Offset(3, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black54,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextFormField(
                        controller: _taskNameController,
                        decoration: InputDecoration(
                          labelText: 'Task name...',
                          border: InputBorder.none,
                          filled: true,
                          fillColor:
                              Theme.of(context).colorScheme.tertiaryContainer,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a task name';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black54,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      // padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextFormField(
                        controller: _taskDescriptionController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: 'Task description...',
                          border: InputBorder.none,
                          filled: true,
                          fillColor:
                              Theme.of(context).colorScheme.tertiaryContainer,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a task description';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black54,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButtonFormField<Section>(
                        decoration: const InputDecoration(
                          labelText: 'Section...',
                        ),
                        items: Section.values
                            .map(
                              (section) => DropdownMenuItem(
                                value: section,
                                child: Text(section.toString().split('.').last),
                              ),
                            )
                            .toList(),
                        onChanged: (Section? value) {
                          setState(() {
                            _selectedSection = value!;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a section';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Recurrent task?",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black54,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  Radio<Recurrence>(
                                    value: Recurrence.none,
                                    groupValue: _selectedRecurrence,
                                    onChanged: _selectRecurrence,
                                  ),
                                  const Text('No'),
                                ],
                              ),
                              Row(
                                children: [
                                  Radio<Recurrence>(
                                    value: Recurrence.daily,
                                    groupValue: _selectedRecurrence,
                                    onChanged: _selectRecurrence,
                                  ),
                                  const Text('Daily'),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  Radio<Recurrence>(
                                    value: Recurrence.weekly,
                                    groupValue: _selectedRecurrence,
                                    onChanged: _selectRecurrence,
                                  ),
                                  const Text('Weekly'),
                                ],
                              ),
                              Row(
                                children: [
                                  Radio<Recurrence>(
                                    value: Recurrence.monthly,
                                    groupValue: _selectedRecurrence,
                                    onChanged: _selectRecurrence,
                                  ),
                                  const Text('Monthly'),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Divider(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      thickness: 2,
                    ),
                    const SizedBox(height: 16),
                    Column(
                      children: [
                        Text(
                          'When to change to medium priority? (if needed)',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                        InkWell(
                          mouseCursor: SystemMouseCursors.click,
                          onTap: () {
                            _openSelectDate(context).then((value) {
                              if (value != null) {
                                setState(() {
                                  _changeToMediumPriorityDate = value;
                                  print(_changeToMediumPriorityDate);
                                });
                              }
                            });
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.calendar_month,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              Text(
                                _changeToMediumPriorityDate == null
                                    ? 'Select date'
                                    : _changeToMediumPriorityDate
                                        .toString()
                                        .split(' ')[0],
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'When to change to high priority? (if needed)',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                        InkWell(
                          mouseCursor: SystemMouseCursors.click,
                          onTap: () {
                            _openSelectDate(context).then((value) {
                              if (value != null) {
                                setState(() {
                                  _changeToHighPriorityDate = value;
                                  print(_changeToHighPriorityDate);
                                });
                              }
                            });
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.calendar_month,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              Text(
                                _changeToHighPriorityDate == null
                                    ? 'Select date'
                                    : _changeToHighPriorityDate
                                        .toString()
                                        .split(' ')[0],
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Divider(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      thickness: 2,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              _selectedRecurrence == Recurrence.none
                                  ? 'Deadline'
                                  : 'Start date',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                            ),
                            InkWell(
                              mouseCursor: SystemMouseCursors.click,
                              onTap: () {
                                _openSelectDate(context).then((value) {
                                  if (value != null) {
                                    setState(() {
                                      _selectedDate = value;
                                    });
                                  }
                                });
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.calendar_month,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                  Text(
                                    _selectedDate == null
                                        ? 'Select date'
                                        : _selectedDate
                                            .toString()
                                            .split(' ')[0],
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              mouseCursor: SystemMouseCursors.click,
                              onTap: () {
                                _selectTime(context);
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                  Text(
                                    _selectedTime == null
                                        ? 'Select time'
                                        : _selectedTime!.format(context),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 180,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (_selectedDate == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Please select a deadline date')),
                              );
                              return;
                            }
                            if (_selectedTime == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Please select a deadline time')),
                              );
                              return;
                            }

                            final task = Task(
                              name: _taskNameController.text,
                              description: _taskDescriptionController.text,
                              section: _selectedSection,
                              priority: Priority.low,
                              recurrence: _selectedRecurrence,
                              deadline: DateTime(
                                _selectedDate!.year,
                                _selectedDate!.month,
                                _selectedDate!.day,
                                _selectedTime!.hour,
                                _selectedTime!.minute,
                              ),
                              changeToMediumPriority:
                                  _changeToMediumPriorityDate,
                              changeToHighPriority: _changeToHighPriorityDate,
                              user: widget.loggedUser,
                              done: false,
                            );

                            saveTaskAPI(task).then((value) {
                              if (context.mounted) {
                                Navigator.of(context).pop(value);
                              }
                            }).catchError((e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to add task: $e'),
                                  ),
                                );
                              }
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Add Task',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
