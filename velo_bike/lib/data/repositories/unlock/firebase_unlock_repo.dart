import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../models/unlock_result.dart';
import 'unlock_repository.dart';

class FirebaseUnlockRepo implements UnlockRepository {
  static const String baseUrl =
      "https://velo-bike-rental-default-rtdb.asia-southeast1.firebasedatabase.app";

  @override
  Future<UnlockResult> unlockBike(String bikeId, String userId) async {
    try {
      //check user pass
      final userUrl = Uri.parse("$baseUrl/users/$userId.json");
      final userRes = await http.get(userUrl);

      if (userRes.statusCode != 200) {
        return UnlockResult(success: false, message: "Failed to fetch user");
      }

      final userData = json.decode(userRes.body);

      final activePassId = userData['activePassId'];

      if (activePassId == null) {
        return UnlockResult(success: false, message: "NO_PASS");
      }

      //check bike status
      final bikeUrl = Uri.parse("$baseUrl/bikes/$bikeId.json");
      final bikeRes = await http.get(bikeUrl);

      if (bikeRes.statusCode != 200) {
        return UnlockResult(success: false, message: "Failed to fetch bike");
      }

      final bikeData = json.decode(bikeRes.body);

      if (bikeData == null) {
        return UnlockResult(success: false, message: "Bike not found");
      }

      if (bikeData['status'] != 'available') {
        return UnlockResult(success: false, message: "Bike is not available");
      }

      //update bike status to 
      final updateRes = await http.patch(
        bikeUrl,
        body: json.encode({
          "status": "in_use",
        }),
      );

      if (updateRes.statusCode != 200) {
        return UnlockResult(success: false, message: "Failed to unlock bike");
      }

      return UnlockResult(
        success: true,
        message: "Bike unlocked successfully",
      );

    } catch (e) {
      return UnlockResult(
        success: false,
        message: e.toString(),
      );
    }
  }
}