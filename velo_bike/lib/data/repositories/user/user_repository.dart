import 'package:velo_bike/models/user.dart';

abstract class UserRepository {
  Future<User?> getUserById(String userId);
  Future<void> updateCurrentRideId(String userId, String? rideId);
}
