import 'package:flutter/material.dart';
import '../../../../data/repositories/unlock/unlock_repository.dart';

enum UnlockStatus { loading, success, failure }

class UnlockViewModel extends ChangeNotifier {
  final UnlockRepository repository;

  UnlockViewModel(this.repository);

  UnlockStatus? status;
  String? message;

  Future<void> unlockBike(String bikeId, String userId) async {
    try {
      status = UnlockStatus.loading;
      message = null;
      notifyListeners();

      final result = await repository.unlockBike(bikeId, userId);

      if (result.success) {
        status = UnlockStatus.success;
      } else {
        status = UnlockStatus.failure;
      }

      message = result.message;

    } catch (e) {
      status = UnlockStatus.failure;
      message = e.toString();
    }

    notifyListeners();
  }
}