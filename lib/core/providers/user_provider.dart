import 'package:flutter/material.dart';
import 'package:flutterwidgets/features/home/models/author_model.dart';

class UserProvider extends ChangeNotifier {
  Author? _selectedUser;

  Author? get selectedUser => _selectedUser;

  void setUser(Author user) {
    _selectedUser = user;
    notifyListeners();
  }

  
  Author get currentUser => _selectedUser ?? Author.users[0];
}
