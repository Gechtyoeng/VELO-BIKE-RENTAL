import 'package:velo_bike/models/bike.dart';

abstract class BikeRepository {
  Future<List<Bike>> getBikesByStation(String stationId);
  Future<Bike?> getBikeById(String bikeId);
  Future<void> markBikeInUse(String bikeId, String userId);
}
