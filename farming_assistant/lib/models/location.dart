import 'package:farming_assistant/models/enums/location_type.dart';
import 'package:farming_assistant/models/user.dart';

class Location{

  String id;
  LocationType type;
  String? name;
  User user;

  Location(this.id, this.type, this.name, this.user);

  static fromJson(Map <String, dynamic> jsonData) {
    return Location(
      jsonData['id'].toString(),
      LocationType.values.byName(jsonData['type'].toString().toLowerCase()),
      jsonData['name'],
      User.fromJson(jsonData['user']),
    );
  }

  static toJson(Location location) {
    return {
      'id': location.id,
      'name': location.name,
      'type': location.type.jsonValue,
      'user': User.toJson(location.user),
    };
  }

}
