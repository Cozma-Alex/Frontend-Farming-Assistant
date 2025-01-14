import 'package:farming_assistant/models/enums/location_type.dart';
import 'package:farming_assistant/models/user.dart';

/// Location model
/// Represents a location in the database with the following fields:
/// - id: UUID - the id of the location (primary key)
/// - type: LocationType - the type of the location (enum)
/// - name: String - the name of the location
/// - user: User - the user that owns the location (foreign key)
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Location &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;

}
