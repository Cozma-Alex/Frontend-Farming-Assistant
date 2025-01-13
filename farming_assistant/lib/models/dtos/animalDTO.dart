import 'package:farming_assistant/models/animal.dart';
import 'package:farming_assistant/models/food_programme.dart';

class AnimalDTO {

  Animal animal;
  List<FoodProgramme> foodProgrammes;

  AnimalDTO(this.animal, this.foodProgrammes);

  static fromJson(Map <String, dynamic> jsonData) {
    return AnimalDTO(
      Animal.fromJson(jsonData['animal']),
      List<FoodProgramme>.from(
          jsonData['foodProgrammes'].map((e) => FoodProgramme.fromJson(e)).toList())
    );
  }

  static toJson(AnimalDTO animalDTO) {
    return {
      'animal': Animal.toJson(animalDTO.animal),
      'foodProgrammes' : animalDTO.foodProgrammes.map((e) => FoodProgramme.toJson(e)).toList(),
    };
  }

}