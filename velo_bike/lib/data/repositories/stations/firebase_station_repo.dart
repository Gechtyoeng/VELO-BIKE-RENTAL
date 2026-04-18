import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:velo_bike/config/firebase_config.dart';
import 'package:velo_bike/data/dtos/station_dto.dart';
import 'package:velo_bike/data/repositories/stations/station_repository.dart';
import 'package:velo_bike/models/station.dart';

class FirebaseStationRepo extends StationRepository {
  @override
  Future<List<Station>> getStations() async {
    final uri = FirebaseConfig.baseUri.replace(path: '/stations.json');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch stations');
    }

    final decoded = json.decode(response.body);

    if (decoded == null) return [];

    final data = decoded as Map<String, dynamic>;

    return data.entries.map((entry) => StationDto.fromJson(entry.key, entry.value).toModel()).toList();
  }

  @override
  Future<Station?> getStationById(String stationId) async {
    final url = FirebaseConfig.baseUri.replace(path: '/stations/$stationId.json');
    final res = await http.get(url);

    if (res.statusCode != 200) {
      throw Exception('Failed to fetch station');
    }

    final decoded = json.decode(res.body);
    if (decoded == null) return null;

    return StationDto.fromJson(stationId, Map<String, dynamic>.from(decoded)).toModel();
  }

  @override
  Future<void> updateAvailableBikes(String stationId, int availableBikes) async {
    final url = FirebaseConfig.baseUri.replace(path: '/stations/$stationId.json');
    final res = await http.patch(url, headers: {'Content-Type': 'application/json'}, body: json.encode({'availableBikes': availableBikes < 0 ? 0 : availableBikes}));

    if (res.statusCode != 200) {
      throw Exception('Failed to update station available bikes');
    }
  }
}
