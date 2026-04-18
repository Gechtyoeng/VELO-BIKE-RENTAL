import 'package:flutter/material.dart';
import 'package:velo_bike/models/user_pass.dart';

class ActivePassNotifier extends ChangeNotifier {
  UserPass? _activePass;

  UserPass? get activePass => _activePass;

  bool get hasActivePass {
    if (_activePass == null) return false;
    return _activePass!.isActive && !_activePass!.isExpired && _activePass!.remainingRides > 0;
  }

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
    if (_activePass != null && (_activePass!.isExpired || _activePass!.remainingRides <= 0)) {
      _activePass = null;
      notifyListeners();
    }
  }
}
