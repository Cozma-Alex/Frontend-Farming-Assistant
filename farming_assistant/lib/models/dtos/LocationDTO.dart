import 'package:farming_assistant/models/coordinate.dart';

import '../location.dart';

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
      'coordinates': locationDTO.coordinates.map((e) => Coordinate.toJson(e)).toList(),
    };
  }
}