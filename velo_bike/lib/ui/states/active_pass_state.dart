import 'package:flutter/material.dart';
import 'package:velo_bike/models/user_pass.dart';

class ActivePassNotifier extends ChangeNotifier {
  UserPass? _activePass;

  UserPass? get activePass => _activePass;

  bool get hasActivePass => _activePass != null && _activePass!.isActive;

  void setActivePass(UserPass pass) {
    _activePass = pass;
    notifyListeners();
  }

  void clearActivePass() {
    _activePass = null;
    notifyListeners();
  }
// refresh when expired and inactive
  void refreshPassStatus() {
    if (_activePass != null && _activePass!.isExpired) {
      _activePass = null;
      notifyListeners();
    }
  }
}
