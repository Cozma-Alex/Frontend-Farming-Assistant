import 'package:farming_assistant/models/user.dart';

class Fertilizer{

  String id;
  String name;
  String description;
  double quantity;
  User user;

  Fertilizer(this.id, this.name, this.description, this.quantity, this.user);

  static fromJson(jsonData) {
    return Fertilizer(
      jsonData['id'],
      jsonData['name'],
      jsonData['description'],
      jsonData['quantity'],
      User.fromJson(jsonData['user']),
    );
  }
}
