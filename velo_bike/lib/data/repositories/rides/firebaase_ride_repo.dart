import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:velo_bike/config/firebase_config.dart';
import 'package:velo_bike/data/dtos/ride_dto.dart';
import 'package:velo_bike/data/repositories/rides/ride_ropository.dart';
import 'package:velo_bike/models/ride.dart';

class FirebaaseRideRepo extends RideRepository {
  @override
  Future<Ride> createRide({required String userId, required String bikeId, required String stationId}) async {
    final url = FirebaseConfig.baseUri.replace(path: '/rides.json');
    final now = DateTime.now().toUtc().toIso8601String();

    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'userId': userId, 'bikeId': bikeId, 'stationId': stationId, 'startTime': now, 'endTime': null, 'status': 'ongoing'}),
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to create ride');
    }

    final decoded = json.decode(res.body);
    final rideId = decoded['name'];

    return Ride(id: rideId, userId: userId, bikeId: bikeId, stationId: stationId, startTime: DateTime.parse(now), endTime: null, status: 'ongoing');
  }

  @override
  Future<List<Ride>> getRidesByUser(String userId) async {
    final url = FirebaseConfig.baseUri.replace(path: '/rides.json');
    final res = await http.get(url);

    if (res.statusCode != 200) {
      throw Exception('Failed to fetch rides');
    }

    final decoded = json.decode(res.body);
    if (decoded == null) return [];

    final data = Map<String, dynamic>.from(decoded);

    return data.entries.map((entry) => RideDto.fromJson(entry.key, Map<String, dynamic>.from(entry.value)).toModel()).where((ride) => ride.userId == userId).toList();
  }
}
