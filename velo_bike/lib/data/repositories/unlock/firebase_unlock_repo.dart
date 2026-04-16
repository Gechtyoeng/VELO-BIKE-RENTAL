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
      //fetch bike data from Firebase
      final url = Uri.parse("$baseUrl/bikes.json");
      final response = await http.get(url);

      if (response.statusCode != 200) {
        return UnlockResult(
          success: false,
          message: "Failed to load bikes from Firebase",
        );
      }

      final data = json.decode(response.body) as Map<String, dynamic>;

      //ind bike
      final bike = data[bikeId];

      if (bike == null) {
        return UnlockResult(
          success: false,
          message: "Bike not found",
        );
      }

      //check status
      if (bike['status'] != 'available') {
        return UnlockResult(
          success: false,
          message: "Bike is not available",
        );
      }

      //imulate unlock success
      //later PATCH Firebase here

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