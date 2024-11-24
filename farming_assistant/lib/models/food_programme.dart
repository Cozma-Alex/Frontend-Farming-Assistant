import 'animal.dart';
import 'food.dart';

class FoodProgramme {

  String id;
  DateTime startHour;
  DateTime endHour;
  Animal animal;
  Food food;

  FoodProgramme(this.id, this.startHour, this.endHour, this.animal, this.food);

  static fromJson(jsonData) {
    return FoodProgramme(
      jsonData['id'],
      DateTime.parse(jsonData['start_hour']),
      DateTime.parse(jsonData['end_hour']),
      Animal.fromJson(jsonData['animal']),
      Food.fromJson(jsonData['food']),
    );
  }

}
