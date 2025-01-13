import 'package:flutter/material.dart';
import '../models/user.dart';

/// This class keeps track of the currently logged user.
/// Uses the [provider] package.
class LoggedUserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void logoutUser() {
    _user = null;
    notifyListeners();
  }
}
