// ignore_for_file: file_names

import 'package:farming_assistant/models/coordinate.dart';

import '../location.dart';


/// Data Transfer Object for Location
/// Contains a Location and a list of Coordinates
/// Used to transfer data between the server and the client
class LocationDTO {
  Location location;
  List<Coordinate> coordinates;

  LocationDTO(this.location, this.coordinates);

  static fromJson(Map<String, dynamic> jsonData) {
    return LocationDTO(
      Location.fromJson(jsonData['location']),
      List<Coordinate>.from(
        jsonData['coordinates'].map((e) => Coordinate.fromJson(e)).toList(),
      ),
    );
  }

  static toJson(LocationDTO locationDTO) {
    return {
      'location': Location.toJson(locationDTO.location),
      'coordinates': locationDTO.coordinates
          .map((e) => Coordinate.toJson(e))
          .toList(),

    };
  }
}