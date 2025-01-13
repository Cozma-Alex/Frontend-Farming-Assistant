import 'dart:convert';

import 'package:farming_assistant/models/food.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../utils/config.dart';

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