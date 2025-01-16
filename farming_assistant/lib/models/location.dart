import 'package:farming_assistant/models/user.dart';

import 'enums/location_type.dart';
/// Location model
/// Represents a location in the database with the following fields:
/// - id: UUID - the id of the location (primary key)
/// - type: LocationType - the type of the location (enum)
/// - name: String - the name of the location
/// - user: User - the user that owns the location (foreign key)
class Location{

class Location {
  String id;
  LocationType type;
  String? name;
  User user;

  Location(this.id, this.type, this.name, this.user);

  static fromJson(Map<String, dynamic> jsonData) {
    String typeStr = jsonData['type'].toString().toLowerCase();
    LocationType locationType;
    try {
      locationType = LocationType.values.firstWhere(
            (type) => type.name.toLowerCase() == typeStr,
        orElse: () => LocationType.other,
      );
    } catch (e) {
      print('Error parsing LocationType: ${jsonData['type']}');
      locationType = LocationType.other;
    }

    return Location(
      jsonData['id'].toString(),
      locationType,
      jsonData['name'],
      User.fromJson(jsonData['user']),
    );
  }

  static Map<String, dynamic> toJson(Location location) {
    return {
      'id': location.id,
      'name': location.name,
      'type': location.type.jsonValue,
      'user': User.toJson(location.user),
    };
  }

  @override
  String toString() {
    return 'Location{id: $id, type: ${type.jsonValue}, name: $name}';
  }
}