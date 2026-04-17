import 'package:flutter/material.dart';
import '../../../../data/repositories/unlock/unlock_repository.dart';


enum UnlockStatus {
  idle,      // initial state show bike info
  loading,   
  success,   
  failure,   
  noPass     // user has no active pass
}

class UnlockViewModel extends ChangeNotifier {
  final UnlockRepository repository;

  UnlockViewModel(this.repository);

  //Current UI state
  UnlockStatus status = UnlockStatus.idle;

  //Message from backend success or error
  String? message;

  // Reset state when reopening bottom sheet or retry
  void reset() {
    status = UnlockStatus.idle;
    message = null;
    notifyListeners();
  }

  //unlock logic
  Future<void> unlockBike(String bikeId, String userId) async {
    try {
      status = UnlockStatus.loading;
      notifyListeners();

      final result = await repository.unlockBike(bikeId, userId);

      //handle result
      if (!result.success) {
        //no pass
        if (result.message == "NO_PASS") {
          status = UnlockStatus.noPass;
        } else {
          status = UnlockStatus.failure;
        }
      } else {
        status = UnlockStatus.success;
      }

      message = result.message;

    } catch (e) {
      status = UnlockStatus.failure;
      message = e.toString();
    }

    notifyListeners();
  }
}