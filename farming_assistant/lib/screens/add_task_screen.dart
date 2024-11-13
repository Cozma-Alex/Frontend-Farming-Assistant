import 'package:flutter/material.dart';

import 'package:farming_assistant/models/task.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  Recurrence _selectedRecurrence = Recurrence.none;

  void _selectRecurrence(Recurrence? recurrence) {
    setState(() {
      _selectedRecurrence = recurrence!;
    });
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
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Task name...',
                          border: InputBorder.none,
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
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextFormField(
                        maxLines: 5,
                        decoration: const InputDecoration(
                          labelText: 'Task description...',
                          border: InputBorder.none,
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
                        onChanged: (Section? value) {},
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
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Radio<Recurrence>(
                                  value: Recurrence.none,
                                  groupValue: _selectedRecurrence,
                                  onChanged: _selectRecurrence,
                                ),
                                const Text('No'),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Radio<Recurrence>(
                                  value: Recurrence.daily,
                                  groupValue: _selectedRecurrence,
                                  onChanged: _selectRecurrence,
                                ),
                                const Text('Daily'),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Radio<Recurrence>(
                                  value: Recurrence.weekly,
                                  groupValue: _selectedRecurrence,
                                  onChanged: _selectRecurrence,
                                ),
                                const Text('Weekly'),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Radio<Recurrence>(
                                  value: Recurrence.monthly,
                                  groupValue: _selectedRecurrence,
                                  onChanged: _selectRecurrence,
                                ),
                                const Text('Monthly'),
                              ],
                            ),
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
                    Container(
                      height: 70,
                      /*decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black54,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),*/
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          Text(
                            'Deadline:',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: InputDatePickerFormField(
                              fieldLabelText: "Enter date (MM/DD/YYYY)",
                              firstDate: DateTime.timestamp(),
                              lastDate: DateTime(DateTime.timestamp().year + 2),
                              initialDate: DateTime.timestamp(),
                              onDateSubmitted: (DateTime value) {},
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {}
                      },
                      child: const Text('Add Task'),
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
