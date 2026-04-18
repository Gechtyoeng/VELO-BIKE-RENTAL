import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:velo_bike/config/firebase_config.dart';
import 'package:velo_bike/data/dtos/bike_dto.dart';
import 'package:velo_bike/data/repositories/bikes/bike_repository.dart';
import 'package:velo_bike/models/bike.dart';

class FirebaseBikeRepo extends BikeRepository {
  @override
  Future<List<Bike>> getBikesByStation(String stationId) async {
    final uri = FirebaseConfig.baseUri.replace(path: '/bikes.json');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch bikes');
    }

    final decoded = json.decode(response.body);

    if (decoded == null) return [];

    final data = decoded as Map<String, dynamic>;

    return data.entries.map((entry) => BikeDto.fromJson(entry.key, entry.value).toModel()).where((bike) => bike.stationId == stationId).toList();
  }
   @override
  Future<Bike?> getBikeById(String bikeId) async {
    final url = FirebaseConfig.baseUri.replace(path: '/bikes/$bikeId.json');
    final res = await http.get(url);

    if (res.statusCode != 200) {
      throw Exception('Failed to fetch bike');
    }

    final decoded = json.decode(res.body);
    if (decoded == null) return null;

    return BikeDto.fromJson(bikeId, Map<String, dynamic>.from(decoded)).toModel();
  }

  @override
  Future<void> markBikeInUse(String bikeId, String userId) async {
    final bike = await getBikeById(bikeId);
    if (bike == null) {
      throw Exception('Bike not found');
    }

    final url = FirebaseConfig.baseUri.replace(path: '/bikes/$bikeId.json');
    final res = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'status': 'in_use', 'currentUserId': userId, 'unlockedAt': DateTime.now().toIso8601String(), 'usedToday': bike.usedToday + 1}),
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to mark bike as in use');
    }
  }
}
