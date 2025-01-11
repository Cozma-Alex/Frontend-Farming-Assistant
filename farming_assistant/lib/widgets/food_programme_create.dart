import 'package:flutter/material.dart';
import '../models/animal.dart';
import '../models/food.dart';
import '../models/food_programme.dart';
import '../APIs/food-related-apis.dart';

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


  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime ?? TimeOfDay.now() : _endTime ?? TimeOfDay.now(),
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
                return DropdownMenuItem(
                  value: food,
                  child: Text(food.name),
                );
              }).toList(),
              onChanged: (Food? value) {
                setState(() {
                  _selectedFood = value;
                });
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
                      isEditMode ? widget.existingProgramme!.animal : null,
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