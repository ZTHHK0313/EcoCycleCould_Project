import 'package:eco_cycle_cloud/model/errors.dart';
import 'package:flutter/material.dart';

import '../identifiable.dart';

final class User implements Identifiable<int> {
  @override
  final int identifier;

  const User(this.identifier);
}

final class CurrentUserManager extends ChangeNotifier {
  User? _current;

  CurrentUserManager();

  void attachUser(User user) {
    assert(!hasCurrentUser);

    _current = user;
    notifyListeners();
  }

  void flushUser() {
    assert(hasCurrentUser);

    _current = null;
    notifyListeners();
  }

  bool get hasCurrentUser => _current != null;

  User get current {
    if (!hasCurrentUser) {
      throw const UserLogoutException();
    }
    
    return _current!;
  } 
}
