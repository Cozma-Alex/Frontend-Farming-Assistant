import 'package:farming_assistant/models/user.dart';

class Tool{
  String id;
  String name;
  String description;
  double quantity;
  User user;

  Tool(this.id, this.name, this.description, this.quantity, this.user);

  static fromJson(jsonData) {
    return Tool(
      jsonData['id'],
      jsonData['name'],
      jsonData['description'],
      jsonData['quantity'],
      User.fromJson(jsonData['user']),
    );
  }
}
