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
      password: jsonData['password_hash'],
      farmName: jsonData['farm_name'],
      name: jsonData['name'],
      imageData: jsonData['image_data'],
    );
  }

  static toJson(User user) {
    return {
      'id': user.id,
      'email': user.email,
      'password_hash': user.password,
      'farm_name': user.farmName,
      'name': user.name,
      'image_data': user.imageData,
    };
  }

  @override
  String toString() {
    return 'User{id: $id, email: $email, password: $password, farmName: $farmName, name: $name}';
  }
}
