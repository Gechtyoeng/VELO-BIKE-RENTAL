import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:velo_bike/config/firebase_config.dart';
import '../../../models/unlock_result.dart';
import 'unlock_repository.dart';

class FirebaseUnlockRepo implements UnlockRepository {
  @override
  Future<UnlockResult> unlockBike(String bikeId, String userId) async {
    try {
      // 1. Fetch user
      final userUrl = FirebaseConfig.baseUri.replace(path: '/users/$userId.json');
      final userRes = await http.get(userUrl);

      if (userRes.statusCode != 200) {
        return UnlockResult(success: false, message: "Failed to fetch user");
      }

      final userData = json.decode(userRes.body);
      if (userData == null) {
        return UnlockResult(success: false, message: "User not found");
      }

      final activePassId = userData['activePassId'];

      if (activePassId == null) {
        return UnlockResult(success: false, message: "NO_PASS");
      }

      // 2. Fetch pass
      final passUrl = FirebaseConfig.baseUri.replace(path: '/userPasses/$activePassId.json');
      final passRes = await http.get(passUrl);

      if (passRes.statusCode != 200) {
        return UnlockResult(success: false, message: "Failed to fetch pass");
      }

      final passData = json.decode(passRes.body);

      if (passData == null) {
        return UnlockResult(success: false, message: "Pass not found");
      }

      final status = passData['status'] ?? 'expired';
      final endDate = DateTime.tryParse(passData['endDate'] ?? '');
      final totalRides = passData['totalRides'] ?? 0;
      final usedRides = passData['usedRides'] ?? 0;
      final remainingRides = totalRides - usedRides;

      if (status != 'active') {
        return UnlockResult(success: false, message: "PASS_INACTIVE");
      }

      if (endDate == null || DateTime.now().isAfter(endDate)) {
        return UnlockResult(success: false, message: "PASS_EXPIRED");
      }

      if (remainingRides <= 0) {
        return UnlockResult(success: false, message: "NO_RIDES_LEFT");
      }

      // 3. Fetch bike
      final bikeUrl = FirebaseConfig.baseUri.replace(path: '/bikes/$bikeId.json');
      final bikeRes = await http.get(bikeUrl);

      if (bikeRes.statusCode != 200) {
        return UnlockResult(success: false, message: "Failed to fetch bike");
      }

      final bikeData = json.decode(bikeRes.body);

      if (bikeData == null) {
        return UnlockResult(success: false, message: "Bike not found");
      }

      if (bikeData['status'] != 'available') {
        return UnlockResult(success: false, message: "BIKE_NOT_AVAILABLE");
      }

      final stationId = bikeData['stationId'];
      if (stationId == null) {
        return UnlockResult(success: false, message: "Bike station not found");
      }

      // 4. Fetch station
      final stationUrl = FirebaseConfig.baseUri.replace(path: '/stations/$stationId.json');
      final stationRes = await http.get(stationUrl);

      if (stationRes.statusCode != 200) {
        return UnlockResult(success: false, message: "Failed to fetch station");
      }

      final stationData = json.decode(stationRes.body);

      if (stationData == null) {
        return UnlockResult(success: false, message: "Station not found");
      }

      final availableBikes = stationData['availableBikes'] ?? 0;

      if (availableBikes <= 0) {
        return UnlockResult(success: false, message: "No bikes available at station");
      }

      // 5. Update bike status
      final updateBikeRes = await http.patch(
        bikeUrl,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"status": "in_use", "currentUserId": userId, "unlockedAt": DateTime.now().toIso8601String()}),
      );

      if (updateBikeRes.statusCode != 200) {
        return UnlockResult(success: false, message: "Failed to unlock bike");
      }

      // 6. Update pass usage
      final updatePassRes = await http.patch(passUrl, headers: {'Content-Type': 'application/json'}, body: json.encode({"usedRides": usedRides + 1}));

      if (updatePassRes.statusCode != 200) {
        return UnlockResult(success: false, message: "Unlocked but failed to update pass");
      }

      // 7. Update station available bike count
      final updateStationRes = await http.patch(stationUrl, headers: {'Content-Type': 'application/json'}, body: json.encode({"availableBikes": availableBikes - 1}));

      if (updateStationRes.statusCode != 200) {
        return UnlockResult(success: false, message: "Unlocked but failed to update station");
      }

      return UnlockResult(success: true, message: "Bike unlocked successfully");
    } catch (e) {
      return UnlockResult(success: false, message: e.toString());
    }
  }
}
