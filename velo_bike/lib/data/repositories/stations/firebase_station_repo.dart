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
}
