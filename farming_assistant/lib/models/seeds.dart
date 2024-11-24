import 'package:farming_assistant/models/user.dart';

class Seeds{
  String id;
  String name;
  String description;
  double quantity;
  User user;

  Seeds(this.id, this.name, this.description, this.quantity, this.user);

  static fromJson(jsonData) {
    return Seeds(
      jsonData['id'],
      jsonData['name'],
      jsonData['description'],
      jsonData['quantity'],
      User.fromJson(jsonData['user']),
    );
  }
}
