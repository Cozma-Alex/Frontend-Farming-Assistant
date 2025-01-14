import 'dart:convert';
import 'package:farming_assistant/models/animal.dart';
import 'package:farming_assistant/models/dtos/animalDTO.dart';
import 'package:farming_assistant/models/location.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../utils/config.dart';

/// Creates a new animal record in the database.
///
/// Takes a [user] for authentication and an [animal] object containing the animal data.
/// The animal must have a valid location and user association.
/// Returns a Future containing the created [Animal] with its server-assigned ID.
///
/// Throws an Exception if:
/// * The API request fails
/// * The server returns an error response
/// * The response cannot be parsed into an Animal object
Future<Animal> saveAnimalAPI(User user, Animal animal) async {
  final uri = Uri.parse('${APIConfig.baseURI}/animals');

  try {
    final response = await http.post(uri,
        headers: {
          'Authorization': animal.location.user.id!,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(Animal.toJson(animal)));

    return Animal.fromJson(jsonDecode(response.body));
  } catch (e) {
    throw Exception('Failed to save animal: $e');
  }
}

/// Retrieves all animals belonging to a specific user.
///
/// Takes a [user] object for authentication and filtering.
/// Returns a Future containing a List of [Animal] objects associated with the user.
///
/// Throws an Exception if the API request fails or the response cannot be parsed.
Future<List<Animal>> getAllAnimalsOfUserAPI(User user) async {
  final uri = Uri.parse('${APIConfig.baseURI}/animals');

  try {
    final response = await http.get(
      uri,
      headers: {
        'Authorization' : user.id!,
        'Content-Type': 'application/json',
      },
    );
    return List<Animal>.from(
        jsonDecode(response.body).map((e) => Animal.fromJson(e)).toList());
  } catch (e) {
    throw Exception('Failed to get animals: $e');
  }
}

/// Retrieves a specific animal by its ID.
///
/// Takes an [animal] object containing at minimum the ID to look up.
/// Returns a Future containing the complete [Animal] object with all its data.
///
/// Throws an Exception if:
/// * The animal ID is invalid
/// * The API request fails
/// * The user doesn't have permission to access the animal
Future<Animal> getAnimalByIdAPI(Animal animal) async {
  final uri = Uri.parse('${APIConfig.baseURI}/animals/${animal.id}');

  try {
    final response = await http.get(
      uri,
      headers: {
        'Authorization': animal.location.user.id!,
        'Content-Type': 'application/json',
      },
    );

    return Animal.fromJson(jsonDecode(response.body));
  } catch (e) {
    throw Exception('Failed to get animal: $e');
  }
}

/// Deletes an animal record from the database.
///
/// Takes an [animal] object containing at minimum the ID of the animal to delete.
/// Returns a Future that completes when the deletion is successful.
///
/// Authorization is required and checked against the animal's associated user.
///
/// Throws an Exception if:
/// * The deletion fails
/// * The animal doesn't exist
/// * The user doesn't have permission to delete the animal
Future<void> deleteAnimalAPI(Animal animal) async {
  final uri = Uri.parse('${APIConfig.baseURI}/animals/${animal.id}');

  try {
    await http.delete(
      uri,
      headers: {
        'Authorization': animal.location.user.id!,
        'Content-Type': 'application/json',
      },
    );
  } catch (e) {
    throw Exception('Failed to delete animal: $e');
  }
}

/// Updates an existing animal's information in the database.
///
/// Takes an [animal] object containing the updated data and the ID of the animal to update.
/// Returns a Future containing the updated [Animal] object as confirmed by the server.
///
/// All fields in the animal object will be updated, so the complete object should be sent
/// even if only some fields are changing.
///
/// Throws an Exception if:
/// * The update fails
/// * The animal doesn't exist
/// * The user doesn't have permission to update the animal
/// * The validation fails for the updated data
Future<Animal> updateAnimalAPI(Animal animal) async {
  final uri = Uri.parse('${APIConfig.baseURI}/animals/${animal.id}');

  try {
    final response = await http.put(
      uri,
      headers: {
        'Authorization': animal.location.user.id!,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(Animal.toJson(animal)),
    );

    return Animal.fromJson(jsonDecode(response.body));
  } catch (e) {
    throw Exception('Failed to update animal: $e');
  }
}

/// Retrieves all animals at a specific location along with their food programmes.
///
/// Takes a [location] object to filter animals by their assigned location.
/// Returns a Future containing a List of [AnimalDTO] objects, which include both
/// the animal data and their associated food programmes.
///
/// Throws an Exception if:
/// * The API request fails
/// * The location doesn't exist
/// * The user doesn't have permission to access the location
Future<List<AnimalDTO>> getAnimalsByLocationAPI(Location location) async {
  final uri = Uri.parse('${APIConfig.baseURI}/animals/location/${location.id}');

  try {
    final response = await http.get(
      uri,
      headers: {
        'Authorization': location.user.id!,
        'Content-Type': 'application/json',
      },
    );

    return List<AnimalDTO>.from(
        jsonDecode(response.body).map((e) => AnimalDTO.fromJson(e)).toList());
  } catch (e) {
    throw Exception('Failed to get animals by location: $e');
  }
}
