import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../utils/config.dart';

/// Authenticates a user and retrieves their profile information.
///
/// Takes a [user] object containing email and password credentials.
/// Returns a Future containing the authenticated [User] with complete profile data.
///
/// Throws an Exception if:
/// * The API request fails
Future<User> loginAPI(User user) async {
  final uri = Uri.parse('${APIConfig.baseURI}/users/auth');

  try {
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': user.email,
        'passwordHash': user.password,
      }),
    );

    return User.fromJson(jsonDecode(response.body));
  } catch (e) {
    throw Exception('Failed to login: $e');
  }
}

/// Creates a new user account in the system.
///
/// Takes a [user] object containing the new user's information.
/// Returns a Future containing the created [User] with server-assigned ID.
///
/// Throws an Exception if:
/// * The API request fails
Future<User> registerAPI(User user) async {
  final uri = Uri.parse('${APIConfig.baseURI}/users');

  try {
    final response = await http.post(uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(User.toJson(user)));

    return User.fromJson(jsonDecode(response.body));
  } catch (e) {
    throw Exception('Failed to register: $e');
  }
}
