import 'dart:convert';

import 'package:farming_assistant/models/animal.dart';
import 'package:farming_assistant/models/food_programme.dart';
import 'package:http/http.dart' as http;

import '../utils/config.dart';

Future<List<FoodProgramme>> saveFoodProgrammesAPI(List<FoodProgramme> foodProgramme) async {
  if (foodProgramme.isEmpty) {
    throw Exception('No food programme to save');
  }
  final uri = Uri.parse('${APIConfig.baseURI}/animals/food-programmes');

  try {
    final response = await http.post(uri,
        headers: {
          'Authorization': foodProgramme[0].animal.location.user.id!,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(foodProgramme.map((e) => FoodProgramme.toJson(e)).toList()));

    return List<FoodProgramme>.from(
        jsonDecode(response.body).map((e) => FoodProgramme.fromJson(e)).toList());
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