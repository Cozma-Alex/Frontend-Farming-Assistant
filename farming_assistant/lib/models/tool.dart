import 'package:farming_assistant/models/user.dart';

class Tool{
  String id;
  String name;
  String description;
  double quantity;
  User user;

  Tool(this.id, this.name, this.description, this.quantity, this.user);

  static fromJson(Map <String, dynamic> jsonData) {
    return Tool(
      jsonData['id'],
      jsonData['name'],
      jsonData['description'],
      jsonData['quantity'],
      User.fromJson(jsonData['user']),
    );
  }

  static toJson(Tool tool) {
    return {
      'id': tool.id,
      'name': tool.name,
      'description': tool.description,
      'quantity': tool.quantity,
      'user': User.toJson(tool.user),
    };
  }
}
