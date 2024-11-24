import 'package:farming_assistant/models/user.dart';

class Yield{
  String id;
  String name;
  String description;
  double quantity;
  User user;

  Yield(this.id, this.name, this.description, this.quantity, this.user);

  static fromJson(jsonData) {
    return Yield(
      jsonData['id'],
      jsonData['name'],
      jsonData['description'],
      jsonData['quantity'],
      User.fromJson(jsonData['user']),
    );
  }
}
