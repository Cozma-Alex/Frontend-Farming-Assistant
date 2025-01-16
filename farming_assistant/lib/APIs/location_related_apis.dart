import 'dart:convert';

Future<List<Location>> getAllLocationsOfUserAPI(User user) async {
  final uri = Uri.parse('${APIConfig.baseURI}/locations');

=======
import 'package:farming_assistant/models/animal.dart';
import 'package:farming_assistant/models/location.dart';
import 'package:http/http.dart' as http;

import '../models/dtos/locationDTO.dart';
import '../models/user.dart';
import '../utils/config.dart';

/// Retrieves all locations associated with a specific user.
///
/// Takes a [user] object for authentication and filtering. Returns all locations
/// that belong to the specified user. The locations are returned as Location objects
/// extracted from LocationDTO responses.
///
/// Returns a Future containing a List of [Location] objects. The returned list
/// may be empty if the user has no registered locations.
///
/// Throws an Exception if:
/// * The API request fails
/// * The authentication fails
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
  }
Future<LocationDTO> saveLocationAPI(Location location, List<Coordinate> coordinates) async {
  final uri = Uri.parse('${APIConfig.baseURI}/locations');

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
}