import 'package:flutter/material.dart';
import 'package:velo_bike/data/repositories/unlock/unlock_repository.dart';
import 'package:velo_bike/ui/states/active_pass_state.dart';
import 'package:velo_bike/ui/states/auth_state.dart';
import '../../../../models/user_pass.dart';

enum UnlockStatus { idle, loading, success, failure, noPass }

class UnlockViewModel extends ChangeNotifier {
  final UnlockRepository repository;
  final AuthState authState;
  final ActivePassNotifier activePassNotifier;

  UnlockViewModel(this.repository, this.authState, this.activePassNotifier);

  UnlockStatus status = UnlockStatus.idle;
  String? message;

  bool get isLoading => status == UnlockStatus.loading;
  bool get isSuccess => status == UnlockStatus.success;
  bool get isFailure => status == UnlockStatus.failure;
  bool get isNoPassState => status == UnlockStatus.noPass;

  void reset() {
    status = UnlockStatus.idle;
    message = null;
    notifyListeners();
  }

  Future<void> unlockBike(String bikeId) async {
    final userId = authState.currentUser?.id;

    if (userId == null) {
      status = UnlockStatus.failure;
      message = "User not logged in";
      notifyListeners();
      return;
    }

    try {
      status = UnlockStatus.loading;
      message = null;
      notifyListeners();

      final result = await repository.unlockBike(bikeId, userId);

      if (!result.success) {
        if (result.message == "NO_PASS") {
          status = UnlockStatus.noPass;
        } else {
          status = UnlockStatus.failure;
        }

        message = _mapErrorMessage(result.message);
      } else {
        status = UnlockStatus.success;
        message = result.message;
        _updateActivePassLocally();
      }

      notifyListeners();
    } catch (e) {
      status = UnlockStatus.failure;
      message = e.toString();
      notifyListeners();
    }
  }

  String _mapErrorMessage(String raw) {
    switch (raw) {
      case "NO_PASS":
        return "You do not have an active pass.";
      case "PASS_INACTIVE":
        return "Your pass is inactive.";
      case "PASS_EXPIRED":
        return "Your pass has expired.";
      case "NO_RIDES_LEFT":
        return "No rides left in your active pass.";
      case "BIKE_NOT_AVAILABLE":
        return "This bike is no longer available.";
      default:
        return raw;
    }
  }

  void _updateActivePassLocally() {
    final currentPass = activePassNotifier.activePass;
    if (currentPass == null) return;

    final updatedPass = UserPass(
      id: currentPass.id,
      userId: currentPass.userId,
      planId: currentPass.planId,
      status: currentPass.status,
      startDate: currentPass.startDate,
      endDate: currentPass.endDate,
      totalRides: currentPass.totalRides,
      usedRides: currentPass.usedRides + 1,
    );

    activePassNotifier.setActivePass(updatedPass);
  }
}
