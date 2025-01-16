import 'dart:convert';

import 'package:farming_assistant/models/animal.dart';
import 'package:farming_assistant/models/food_programme.dart';
import 'package:http/http.dart' as http;

import '../utils/config.dart';


/// Creates or updates multiple food programmes in the database.
///
/// Takes a List of [FoodProgramme] objects to be saved. The list must not be empty.
/// Each food programme must have an associated animal and the animal must have a valid
/// location and user association for authorization.
///
/// Returns a Future containing a List of [FoodProgramme] objects as saved in the database,
/// including server-assigned IDs for new programmes.
///
/// Throws an Exception if:
/// * The input list is empty
/// * Any programme lacks required associations (animal, location, user)
/// * The API request fails
/// * The user doesn't have permission to save programmes for the animal
Future<List<FoodProgramme>> saveFoodProgrammesAPI(List<FoodProgramme> foodProgramme) async {
  if (foodProgramme.isEmpty) {
    throw Exception('No food programme to save');
  }
  final uri = Uri.parse('${APIConfig.baseURI}/animals/food-programmes');

  try {
    final response = await http.post(uri,
        headers: {
          'Authorization': foodProgramme[0].animal!.location.user.id!,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(foodProgramme.map((e) => FoodProgramme.toJson(e)).toList()));

    return List<FoodProgramme>.from(
        jsonDecode(response.body).map((e) => FoodProgramme.fromJson(e)).toList());
  } catch (e) {
    throw Exception('Failed to save food programmes: $e');
  }
}


/// Retrieves all food programmes associated with a specific animal.
///
/// Takes an [animal] object containing at minimum the ID of the animal whose
/// food programmes should be retrieved. The animal must have a valid location
/// and user association for authorization purposes.
///
/// Returns a Future containing a List of [FoodProgramme] objects.
/// The returned list may be empty if no food programmes exist for the animal.
///
/// Throws an Exception if:
/// * The API request fails
/// * The user doesn't have permission to access the animal's data
Future<List<FoodProgramme>> getFoodProgrammeForAnimalAPI(Animal animal) async {
  final uri = Uri.parse('${APIConfig.baseURI}/animals/${animal.id}/food-programmes');

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