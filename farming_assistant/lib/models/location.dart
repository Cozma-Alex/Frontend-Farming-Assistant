import 'package:farming_assistant/models/enums/location_type.dart';
import 'package:farming_assistant/models/user.dart';

class Location{

  String id;
  LocationType type;
  User user;

  Location(this.id, this.type, this.user);

  static fromJson(jsonData) {
    return Location(
      jsonData['id'],
      LocationType.values[jsonData['type']],
      User.fromJson(jsonData['user']),
    );
  }

}