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
      final url = Uri.parse("$baseUrl/bikes/$bikeId.json");
      final response = await http.get(url);

      if (response.statusCode != 200) {
        return UnlockResult(
          success: false,
          message: "Failed to fetch bike",
        );
      }

      final data = json.decode(response.body);

      if (data == null) {
        return UnlockResult(
          success: false,
          message: "Bike not found",
        );
      }

      if (data['status'] != 'available') {
        return UnlockResult(
          success: false,
          message: "Bike is not available",
        );
      }

      //simulate success 
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