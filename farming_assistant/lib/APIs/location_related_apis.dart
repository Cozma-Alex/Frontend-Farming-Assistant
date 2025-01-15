import 'dart:convert';
import 'package:farming_assistant/models/location.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/coordinate.dart';
import '../models/dtos/locationDTO.dart';
import '../models/enums/location_type.dart';
import '../models/user.dart';
import '../utils/config.dart';

Future<List<Location>> getLocations(int page, {int limit = 4}) async {
  await Future.delayed(const Duration(seconds: 1));

  final user = User(id: '1', email: 'test@example.com', password: 'password', farmName: 'Test Farm', name: 'John Doe');

  final locations = List.generate(11, (index) =>
      Location(
          'loc_${index + 1}',
          LocationType.values[index % LocationType.values.length],
          "Location",
          user
      )
  );

  return locations;
}

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


Future<LocationDTO> saveLocationAPI(Location location, List<Coordinate> coordinates) async {
  final uri = Uri.parse('${APIConfig.baseURI}/locations');

  try {
    final dto = {
      'location': Location.toJson(location),
      'coordinates': coordinates.map((c) => Coordinate.toJson(c)).toList(),
    };

    final response = await http.post(
      uri,
      headers: {
        'Authorization': location.user.id!,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(dto),
    );

    if (response.statusCode != 200) {
      throw Exception('Server returned status code: ${response.statusCode}');
    }

    return LocationDTO.fromJson(jsonDecode(response.body));
  } catch (e) {
    throw Exception('Failed to save location: $e');
  }
}