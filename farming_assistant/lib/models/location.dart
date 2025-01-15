import 'package:farming_assistant/models/user.dart';

import 'enums/location_type.dart';

class Location {
  String id;
  LocationType type;
  String? name;
  User user;

  Location(this.id, this.type, this.name, this.user);

  static fromJson(Map<String, dynamic> jsonData) {
    return Location(
      jsonData['id'].toString(),
      LocationType.values.byName(jsonData['type'].toString().toLowerCase()),
      jsonData['name'],
      User.fromJson(jsonData['user']),
    );
  }

  static Map<String, dynamic> toJson(Location location) {
    return {
      'name': location.name,
      'type': location.type.jsonValue,  // This uses the jsonValue getter to get the correct server enum value
      'user': User.toJson(location.user),
    };
  }

  @override
  String toString() {
    return 'Location{id: $id, type: ${type.jsonValue}, name: $name}';
  }
}