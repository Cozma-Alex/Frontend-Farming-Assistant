import 'dart:convert';
import 'package:farming_assistant/models/animal.dart';
import 'package:farming_assistant/models/location.dart';
import 'package:http/http.dart' as http;

import '../models/dtos/LocationDTO.dart';
import '../models/user.dart';
import '../utils/config.dart';

Future<List<Location>> getAllLocationsOfUserAPI(User user) async {
  final uri = Uri.parse('${APIConfig.baseURI}/locations');

  try {
    final response = await http.get(
      uri,
      headers: {
        'Authorization' : user.id!,
        'Content-Type': 'application/json',
      },
    );
    return List<Location>.from(
        jsonDecode(response.body).map((e) => LocationDTO.fromJson(e).location).toList());
  } catch (e) {
    throw Exception('Failed to get locations: $e');
  }
}