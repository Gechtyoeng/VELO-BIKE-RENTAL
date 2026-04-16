import '../../../models/unlock_result.dart';

abstract class UnlockRepository {
  Future<UnlockResult> unlockBike(String bikeId, String userId);
}