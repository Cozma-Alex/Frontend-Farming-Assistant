import 'dart:convert';

import 'package:farming_assistant/models/food.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../utils/config.dart';

/// Creates a new food record in the database.
///
/// Takes a [food] object containing the food details to be saved. The food object
/// must have a valid user association for authorization purposes.
///
/// Returns a Future containing the saved [Food] object with its server-assigned ID.
///
/// Throws an Exception if:
/// * The food data is invalid
/// * The API request fails

Future<Food> saveFoodAPI(Food food) async {
  final uri = Uri.parse('${APIConfig.baseURI}/foods');

  try {
    final response = await http.post(uri,
        headers: {
          'Authorization': food.user.id!,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(Food.toJson(food)));

    return Food.fromJson(jsonDecode(response.body));
  } catch (e) {
    throw Exception('Failed to save food: $e');
  }
}

/// Retrieves all food records associated with a specific user.
///
/// Takes a [user] object for authentication and filtering. Returns all food
/// records that belong to the specified user.
///
/// Returns a Future containing a List of [Food] objects.
/// The returned list may be empty if the user has no food records.
///
/// Throws an Exception if:
/// * The API request fails
/// * The authentication fails
Future<List<Food>> getAllFoodsForUserAPI(User user) async {
  final uri = Uri.parse('${APIConfig.baseURI}/foods');

  try {
    final response = await http.get(
      uri,
      headers: {
        'Authorization': user.id!,
        'Content-Type': 'application/json',
      },
    );

    return List<Food>.from(
        jsonDecode(response.body).map((e) => Food.fromJson(e)).toList());
  } catch (e) {
    throw Exception('Failed to get foods: $e');
  }
}