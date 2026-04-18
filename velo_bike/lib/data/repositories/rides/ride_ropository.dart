import 'package:velo_bike/models/ride.dart';

abstract class RideRepository {
  Future<Ride> createRide({required String userId, required String bikeId, required String stationId});
  Future<List<Ride>> getRidesByUser(String userId);
}
