import 'dart:convert';

import '../models/coordinate.dart';
import '../models/dtos/locationDTO.dart';
import '../models/location.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;
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
  final response = await http.get(
    uri,
    headers: {
      'Authorization': user.id!,
      'Content-Type': 'application/json',
    },
  );
  return List<Location>.from(jsonDecode(response.body)
      .map((e) => LocationDTO.fromJson(e).location)
      .toList());
}

/// Saves a location and its associated coordinates to the backend system.
///
/// Takes a [location] object containing the location details and a [coordinates] list
/// containing the geographical coordinates that define the location's boundaries.
/// The location must have a valid user object attached for authentication.
///
/// Makes a POST request to the locations endpoint with both location and coordinate
/// data combined in a single payload. The location data is converted to JSON format
/// before sending.
///
/// Returns a Future containing a [Location] object representing the saved location
/// as returned by the server. The returned location will have a server-generated ID
/// and may contain additional fields populated by the backend.
///
/// Throws an Exception if:
/// * The API request fails with a non-200 status code
/// * The server returns invalid or unparseable data
/// * The authentication token (user ID) is missing or invalid
/// * The JSON conversion fails
Future<LocationDTO> saveLocationAPI(
    Location location, List<Coordinate> coordinates) async {
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
