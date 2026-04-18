import 'package:velo_bike/models/pass_plan.dart';
import 'package:velo_bike/models/user_pass.dart';

abstract class PassRepository {
  Future<List<PassPlan>> getPassPlans();
  Future<List<UserPass>> getUserPasses(String userId);
  Future<UserPass?> getUserPassById(String passId);
  Future<UserPass> buyPass(String userId, PassPlan plan);
  Future<void> updateUsedRides(String passId, int usedRides);
}
