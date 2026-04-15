import 'package:flutter/material.dart';
import 'package:velo_bike/data/repositories/user/user_repository.dart';
import 'package:velo_bike/models/user.dart';

class AuthState extends ChangeNotifier {
  final UserRepository userRepository;

  AuthState(this.userRepository);

  User? currentUser;
  bool isLoading = false;
  String? error;

  Future loadUser(String userId) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      currentUser = await userRepository.getUserById(userId);
      print(currentUser?.email);
      if (currentUser == null) {
        error = 'user not found.';
      }
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }
}
