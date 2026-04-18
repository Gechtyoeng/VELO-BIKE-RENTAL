import 'package:flutter/material.dart';
import 'package:velo_bike/data/repositories/pass/pass_repository.dart';
import 'package:velo_bike/models/pass_plan.dart';
import 'package:velo_bike/models/user_pass.dart';
import 'package:velo_bike/ui/states/active_pass_state.dart';
import 'package:velo_bike/ui/states/auth_state.dart';

class PassViewModel extends ChangeNotifier {
  final PassRepository passRepository;
  final AuthState authState;
  final ActivePassNotifier activePassNotifier;

  PassViewModel(this.authState, this.passRepository, this.activePassNotifier);

  List<PassPlan> _plans = [];
  List<UserPass> _purchasedPasses = [];
  UserPass? _activePass;
  PassPlan? _selectedPlan;

  bool _isLoading = false;
  String? _error;

  List<PassPlan> get plans => _plans;
  List<UserPass> get purchasedPasses => _purchasedPasses;
  UserPass? get activePass => _activePass;
  PassPlan? get selectedPlan => _selectedPlan;

  bool get isLoading => _isLoading;
  String? get error => _error;

  List<UserPass> get previousPasses {
    final passes = _purchasedPasses.where((pass) => !pass.isActive).toList();
    passes.sort((a, b) => b.endDate.compareTo(a.endDate));
    return passes;
  }

  // ================= LOAD PASSES
  Future<void> loadPassData() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _plans = await passRepository.getPassPlans();

      final userId = authState.currentUser?.id;

      if (userId != null) {
        _purchasedPasses = await passRepository.getUserPasses(userId);

        try {
          _activePass = _purchasedPasses.firstWhere((pass) => _isPassUsable(pass));
          activePassNotifier.setActivePass(_activePass!);
        } catch (_) {
          _activePass = null;
          activePassNotifier.clearActivePass();
        }
      } else {
        _purchasedPasses = [];
        _activePass = null;
        activePassNotifier.clearActivePass();
      }
    } catch (e) {
      _error = 'Failed to load pass data: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectPlan(PassPlan plan) {
    _selectedPlan = plan;
    notifyListeners();
  }

  // ================= BUY PASS
  Future<void> buyPlan() async {
    if (_selectedPlan == null) return;

    try {
      final userId = authState.currentUser?.id;
      if (userId == null) {
        _error = 'User not logged in';
        notifyListeners();
        return;
      }

      if (hasUsableActivePass) {
        _error = 'You already have an active pass. Please use it first or wait until it expires.';
        notifyListeners();
        return;
      }

      final newPass = await passRepository.buyPass(userId, _selectedPlan!);

      _purchasedPasses.add(newPass);

      if (_isPassUsable(newPass)) {
        _activePass = newPass;
        activePassNotifier.setActivePass(newPass);
      } else {
        _activePass = null;
        activePassNotifier.clearActivePass();
      }

      _selectedPlan = null;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to buy pass: $e';
      notifyListeners();
    }
  }

  // HELPERS
  String getPlanNameById(String planId) {
    try {
      return _plans.firstWhere((plan) => plan.id == planId).name;
    } catch (_) {
      return 'Unknown Pass';
    }
  }

  PassPlan? getPlanById(String planId) {
    try {
      return _plans.firstWhere((plan) => plan.id == planId);
    } catch (_) {
      return null;
    }
  }

  bool _isPassUsable(UserPass pass) {
    return pass.isActive && !pass.isExpired && pass.remainingRides > 0;
  }

  bool get hasUsableActivePass {
    return _activePass != null && _isPassUsable(_activePass!);
  }

  bool get canBuyNewPass => !hasUsableActivePass; // can purchase pass only when no active pass
}
