import 'package:farming_assistant/models/user.dart';

/// Tool model
/// Contains all data about a tool with the following attributes:
/// - id: UUID - the id of the tool (primary key)
/// - name: String - the name of the tool
/// - description: String - the description of the tool
/// - quantity: double - the quantity of the tool
/// - user: User - the user that owns the tool
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
