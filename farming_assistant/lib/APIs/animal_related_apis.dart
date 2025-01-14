import 'dart:convert' show jsonDecode, jsonEncode;
import 'package:farming_assistant/models/animal.dart';
import 'package:farming_assistant/models/dtos/animalDTO.dart';
import 'package:farming_assistant/models/location.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../utils/config.dart';

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



