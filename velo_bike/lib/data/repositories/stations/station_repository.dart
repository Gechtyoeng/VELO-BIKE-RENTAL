import 'package:velo_bike/models/station.dart';

abstract class StationRepository {
  Future<List<Station>> getStations();
   Future<Station?> getStationById(String stationId);
  Future<void> updateAvailableBikes(String stationId, int availableBikes);
}