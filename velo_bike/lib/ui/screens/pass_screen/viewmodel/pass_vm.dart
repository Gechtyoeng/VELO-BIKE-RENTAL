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
          _activePass = _purchasedPasses.firstWhere((pass) => pass.isActive);

          activePassNotifier.setActivePass(_activePass!);
        } catch (_) {
          _activePass = null;
          activePassNotifier.clearActivePass();
        }
      } else {
        _purchasedPasses = [];
        _activePass = null;
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

      final newPass = await passRepository.buyPass(userId, _selectedPlan!);

      _purchasedPasses.add(newPass);

      if (newPass.isActive) {
        _activePass = newPass;
        activePassNotifier.setActivePass(newPass);
      }

      _selectedPlan = null; // reset selection

      notifyListeners();
    } catch (e) {
      _error = 'Failed to buy pass: $e';
      notifyListeners();
    }
  }

  // ================= USE PASS 
  Future<void> useActivePass() async {
    if (_activePass == null) return;

    if (_activePass!.remainingRides <= 0) {
      _error = "No rides left";
      notifyListeners();
      return;
    }

    final updatedPass = UserPass(
      id: _activePass!.id,
      userId: _activePass!.userId,
      planId: _activePass!.planId,
      status: _activePass!.status,
      startDate: _activePass!.startDate,
      endDate: _activePass!.endDate,
      totalRides: _activePass!.totalRides,
      usedRides: _activePass!.usedRides + 1,
    );

    await passRepository.updateUserPass(updatedPass);

    // update local state
    _activePass = updatedPass;

    final index = _purchasedPasses.indexWhere((p) => p.id == updatedPass.id);
    if (index != -1) {
      _purchasedPasses[index] = updatedPass;
    }

    activePassNotifier.setActivePass(updatedPass);

    notifyListeners();
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
}
