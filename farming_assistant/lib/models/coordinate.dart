import 'location.dart';

class Coordinate{
  String id;
  double latitude;
  double longitude;
  int position;
  Location location;

  Coordinate(this.id, this.latitude, this.longitude, this.position, this.location);

  static fromJson(jsonData) {
    return Coordinate(
      jsonData['id'],
      jsonData['latitude'],
      jsonData['longitude'],
      jsonData['position'],
      Location.fromJson(jsonData['location']),
    );
  }
}
