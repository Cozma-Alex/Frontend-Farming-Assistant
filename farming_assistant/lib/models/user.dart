import "dart:typed_data";

class User {
  String? id;
  String? email;
  String? password;
  String? farmName;
  String? name;
  Uint8List? imageData;

  User({this.id, this.email, this.password, this.farmName, this.name, this.imageData});

  static fromJson(Map <String, dynamic> jsonData) {
    return User(
      id: jsonData['id'],
      email: jsonData['email'],
      password: jsonData['passwordHash'],
      farmName: jsonData['farmName'],
      name: jsonData['name'],
      imageData: jsonData['imageData'],
    );
  }

  static toJson(User user) {
    return {
      'id': user.id,
      'email': user.email,
      'passwordHash': user.password,
      'farmName': user.farmName,
      'name': user.name,
      'imageData': user.imageData,
    };
  }

  @override
  String toString() {
    return 'User{id: $id, email: $email, password: $password, farmName: $farmName, name: $name}';
  }
}
