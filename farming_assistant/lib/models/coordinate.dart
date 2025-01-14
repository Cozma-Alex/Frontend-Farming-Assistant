import 'location.dart';

/// Coordinate model
/// Represents a coordinate in the database having the following fields:
/// - id: UUID (unique identifier of the coordinate) [PK]
/// - latitude: double (latitude of the coordinate)
/// - longitude: double (longitude of the coordinate)
/// - position: int (position of the coordinate in the location)
/// - location: Location (location of the coordinate)
class Coordinate{
  String id;
  double latitude;
  double longitude;
  int position;
  Location location;

  Coordinate(this.id, this.latitude, this.longitude, this.position, this.location);

  static fromJson(Map <String, dynamic> jsonData) {
    return Coordinate(
      jsonData['id'],
      jsonData['latitude'],
      jsonData['longitude'],
      jsonData['position'],
      Location.fromJson(jsonData['location']),
    );
  }

  static toJson(Coordinate coordinate) {
    return {
      'id': coordinate.id,
      'latitude': coordinate.latitude,
      'longitude': coordinate.longitude,
      'position': coordinate.position,
      'location': Location.toJson(coordinate.location),
    };
  }
}
