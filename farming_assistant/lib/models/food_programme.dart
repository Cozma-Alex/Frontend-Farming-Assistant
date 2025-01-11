import 'package:flutter/material.dart';

import '../utils/date_time_formater.dart';
import 'animal.dart';
import 'food.dart';

class FoodProgramme {

  String id;
  TimeOfDay startHour;
  TimeOfDay? endHour;
  Animal? animal;
  Food food;

  FoodProgramme(this.id, this.startHour, this.endHour, this.animal, this.food);

  static TimeOfDay _parseTimeString(String timeStr) {
    // Expected format from backend: "HH:mm:ss" or "HH:mm"
    final parts = timeStr.split(':');
    return TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1])
    );
  }

  static String _formatTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00';
  }

  static fromJson(Map <String, dynamic> jsonData) {
    return FoodProgramme(
      jsonData['id'],
      _parseTimeString(jsonData['startHour']),
      jsonData['endHour'] != null ? _parseTimeString(jsonData['endHour']) : null,
      Animal.fromJson(jsonData['animal']),
      Food.fromJson(jsonData['food']),
    );
  }

  static toJson(FoodProgramme foodProgramme) {
    return {
      'id': foodProgramme.id,
      'startHour': _formatTimeOfDay(foodProgramme.startHour),
      'endHour': foodProgramme.endHour != null ? _formatTimeOfDay(foodProgramme.endHour!) : null,
      'animal': Animal.toJson(foodProgramme.animal!),
      'food': Food.toJson(foodProgramme.food),
    };
  }

}
