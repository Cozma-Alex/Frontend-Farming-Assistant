import 'package:flutter/material.dart';
import '../models/food.dart';
import '../models/food_programme.dart';
import '../APIs/food_related_apis.dart';

/// A dialog for creating or editing animal food programmes.
///
/// This dialog provides a form interface for:
/// - Selecting food from available options
/// - Setting feeding start time
/// - Setting optional end time
///
/// Supports two modes:
/// - Create mode: When [existingProgramme] is null
/// - Edit mode: When [existingProgramme] contains a programme to modify
///
/// Returns a [FoodProgramme] object when saved, or null if cancelled.
class AddFoodProgrammeDialog extends StatefulWidget {
  final List<Food> availableFoods;
  final FoodProgramme? existingProgramme; // Optional, for edit mode

  const AddFoodProgrammeDialog({
    super.key,
    required this.availableFoods,
    this.existingProgramme, // Pass null for create mode
  });

  @override
  State<AddFoodProgrammeDialog> createState() => _AddFoodProgrammeDialogState();
}

class _AddFoodProgrammeDialogState extends State<AddFoodProgrammeDialog> {
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  Food? _selectedFood;
  bool isEditMode = false;

  /// Initializes the dialog state based on mode.
  ///
  /// In edit mode:
  /// - Sets the selected food
  /// - Populates start and end times
  /// - Enables edit mode UI
  ///
  /// In create mode:
  /// - Initializes empty form
  @override
  void initState() {
    super.initState();
    if (widget.existingProgramme != null) {
      isEditMode = true;
      _startTime = TimeOfDay(
        hour: widget.existingProgramme!.startHour.hour,
        minute: widget.existingProgramme!.startHour.minute,
      );
      _endTime = widget.existingProgramme!.endHour != null
          ? TimeOfDay(
              hour: widget.existingProgramme!.endHour!.hour,
              minute: widget.existingProgramme!.endHour!.minute,
            )
          : null;
      _selectedFood = widget.existingProgramme!.food;
    }
  }

  /// Shows time picker dialog for selecting start/end times.
  ///
  /// Takes [isStartTime] to determine which time field to update.
  /// Uses the current value as initial time if set, otherwise uses current time.
  /// Updates state with selected time when user confirms.
  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? _startTime ?? TimeOfDay.now()
          : _endTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  /// Builds the dialog UI with food and time selection form.
  ///
  /// Creates a form with:
  /// - Dropdown for food selection
  /// - Time pickers for start/end times
  /// - Cancel/Save buttons
  ///
  /// The save button is enabled only when required fields (food and start time)
  /// are filled. When save is pressed, returns a new or updated FoodProgramme.
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEditMode ? 'Edit Food Programme' : 'Add Food Programme',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<Food>(
              value: _selectedFood,
              decoration: InputDecoration(
                labelText: 'Select Food',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: widget.availableFoods.map((food) {
                return DropdownMenuItem<Food>(
                  value: food,
                  child: Text(food.name),
                );
              }).toList(),
              onChanged: (Food? value) {
                setState(() {
                  _selectedFood = value;
                });
              },
              isExpanded: true,
              selectedItemBuilder: (BuildContext context) {
                return widget.availableFoods.map<Widget>((Food food) {
                  return Text(food.name);
                }).toList();
              },
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => _selectTime(context, true),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Start Time',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_startTime?.format(context) ?? 'Select time'),
                    const Icon(Icons.access_time),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => _selectTime(context, false),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'End Time (Optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_endTime?.format(context) ?? 'Select time'),
                    const Icon(Icons.access_time),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: (_selectedFood != null && _startTime != null)
                      ? () {
                          final foodProgramme = FoodProgramme(
                            isEditMode ? widget.existingProgramme!.id : '',
                            _startTime!,
                            _endTime,
                            isEditMode
                                ? widget.existingProgramme!.animal
                                : null,
                            _selectedFood!,
                          );
                          Navigator.pop(context, foodProgramme);
                        }
                      : null,
                  child: Text(isEditMode ? 'Save' : 'Add'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
