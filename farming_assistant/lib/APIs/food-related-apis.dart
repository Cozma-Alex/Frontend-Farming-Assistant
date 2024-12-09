import 'dart:convert';
import 'package:farming_assistant/models/animal.dart';
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