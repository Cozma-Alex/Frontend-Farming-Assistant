import "dart:typed_data";

/// User model
/// This class is used to create a user object with the following attributes:
/// - id: UUID - the id of the user (primary key)
/// - email: String - the email of the user
/// - passwordHash: String - the password hash of the user's password
/// - farmName: String - the name of the farm
/// - name: String - the name of the user
/// - imageData: Uint8List - the image data of the user as a byte array
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
