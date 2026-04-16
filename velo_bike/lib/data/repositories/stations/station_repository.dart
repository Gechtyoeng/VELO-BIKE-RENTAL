import 'package:velo_bike/models/station.dart';

abstract class StationRepository {
  Future<List<Station>> getStations();
}