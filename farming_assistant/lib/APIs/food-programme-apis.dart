import 'dart:convert';
import 'package:farming_assistant/models/animal.dart';
import 'package:farming_assistant/models/food_programme.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../utils/config.dart';

Future<Animal> saveFoodProgrammeAPI(FoodProgramme foodProgramme) async {
  final uri = Uri.parse('${APIConfig.baseURI}/animals');

  try {
    final response = await http.post(uri,
        headers: {
          'Authorization': foodProgramme.animal.location.user.id!,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(FoodProgramme.toJson(foodProgramme)));

    return Animal.fromJson(jsonDecode(response.body));
  } catch (e) {
    throw Exception('Failed to save animal: $e');
  }
}

Future<List<FoodProgramme>> getFoodProgrammeForAnimalAPI(Animal animal) async {
  final uri = Uri.parse('${APIConfig.baseURI}/animal/${animal.id}/food-programmes');

  try {
    final response = await http.get(
      uri,
      headers: {
        'Authorization': animal.location.user.id!,
        'Content-Type': 'application/json',
      },
    );

    return List<FoodProgramme>.from(
        jsonDecode(response.body).map((e) => FoodProgramme.fromJson(e)).toList());
  } catch (e) {
    throw Exception('Failed to get food programmes: $e');
  }
}