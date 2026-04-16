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
}
