import 'package:farming_assistant/models/user.dart';

class Food{
  String id;
  String name;
  String description;
  double quantity;
  User user;

  Food(this.id, this.name, this.description, this.quantity, this.user);

  static fromJson(jsonData) {
    return Food(
      jsonData['id'],
      jsonData['name'],
      jsonData['description'],
      jsonData['quantity'],
      User.fromJson(jsonData['user']),
    );
  }
}