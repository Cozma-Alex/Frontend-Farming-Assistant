import '../utils/date_time_formater.dart';
import 'animal.dart';
import 'food.dart';

class FoodProgramme {

  String id;
  DateTime startHour;
  DateTime endHour;
  Animal animal;
  Food food;

  FoodProgramme(this.id, this.startHour, this.endHour, this.animal, this.food);

  static fromJson(Map <String, dynamic> jsonData) {
    return FoodProgramme(
      jsonData['id'],
      DateTime.parse(jsonData['startHour']),
      DateTime.parse(jsonData['endHour'] ?? "0000-00-00T00:00:00.000Z"),
      Animal.fromJson(jsonData['animal']),
      Food.fromJson(jsonData['food']),
    );
  }

  static toJson(FoodProgramme foodProgramme) {
    return {
      'id': foodProgramme.id,
      'startHour': formatDateTimeString(foodProgramme.startHour),
      'endHour': formatDateTimeString(foodProgramme.endHour),
      'animal': Animal.toJson(foodProgramme.animal),
      'food': Food.toJson(foodProgramme.food),
    };
  }

}
