import 'package:velo_bike/data/repositories/bikes/bike_repository.dart';
import 'package:velo_bike/data/repositories/pass/pass_repository.dart';
import 'package:velo_bike/data/repositories/rides/ride_ropository.dart';
import 'package:velo_bike/data/repositories/stations/station_repository.dart';
import 'package:velo_bike/data/repositories/user/user_repository.dart';
import 'package:velo_bike/models/unlock_result.dart';
import 'package:velo_bike/models/user_pass.dart';
import 'unlock_repository.dart';

class FirebaseUnlockRepo implements UnlockRepository {
  final UserRepository userRepository;
  final PassRepository passRepository;
  final BikeRepository bikeRepository;
  final StationRepository stationRepository;
  final RideRepository rideRepository;

  FirebaseUnlockRepo({required this.userRepository, required this.passRepository, required this.bikeRepository, required this.stationRepository, required this.rideRepository});

  @override
  Future<UnlockResult> unlockBike(String bikeId, String userId) async {
    try {
      final user = await userRepository.getUserById(userId);
      if (user == null) {
        return UnlockResult(success: false, message: 'User not found');
      }

      final activePassId = user.activePassId;
      if (activePassId == null) {
        return UnlockResult(success: false, message: 'NO_PASS');
      }

      final pass = await passRepository.getUserPassById(activePassId);
      if (pass == null) {
        return UnlockResult(success: false, message: 'Pass not found');
      }

      final passValidation = _validatePass(pass);
      if (passValidation != null) {
        return passValidation;
      }

      final bike = await bikeRepository.getBikeById(bikeId);
      if (bike == null) {
        return UnlockResult(success: false, message: 'Bike not found');
      }

      if (bike.status != 'available') {
        return UnlockResult(success: false, message: 'BIKE_NOT_AVAILABLE');
      }

      final station = await stationRepository.getStationById(bike.stationId);
      if (station == null) {
        return UnlockResult(success: false, message: 'Station not found');
      }

      if (station.availableBikes <= 0) {
        return UnlockResult(success: false, message: 'No bikes available at station');
      }

      await bikeRepository.markBikeInUse(bike.id, userId);
      await passRepository.updateUsedRides(pass.id, pass.usedRides + 1);
      await stationRepository.updateAvailableBikes(station.id, station.availableBikes - 1);

      final ride = await rideRepository.createRide(userId: userId, bikeId: bike.id, stationId: station.id);

      await userRepository.updateCurrentRideId(userId, ride.id);

      return UnlockResult(success: true, message: 'Bike unlocked successfully');
    } catch (e) {
      return UnlockResult(success: false, message: e.toString());
    }
  }

  UnlockResult? _validatePass(UserPass pass) {
    if (pass.status != 'active') {
      return UnlockResult(success: false, message: 'PASS_INACTIVE');
    }

    if (pass.isExpired) {
      return UnlockResult(success: false, message: 'PASS_EXPIRED');
    }

    if (pass.remainingRides <= 0) {
      return UnlockResult(success: false, message: 'NO_RIDES_LEFT');
    }

    return null;
  }
}
