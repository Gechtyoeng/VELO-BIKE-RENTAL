import 'package:flutter/material.dart';
import 'package:velo_bike/data/repositories/stations/station_repository.dart';
import 'package:velo_bike/models/station.dart';

class MapViewModel extends ChangeNotifier {
  final StationRepository stationRepository;

  MapViewModel(this.stationRepository);

  List<Station> _allStations = [];
  List<Station> _stations = [];

  bool _isLoading = false;
  String? _error;

  List<Station> get stations => _stations;
  bool get isLoading => _isLoading;
  String? get error => _error;

  bool isStationAvailable(Station station) => station.availableBikes > 0;

  Future<void> loadStations() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final fetchedStations = await stationRepository.getStations();

      _allStations = fetchedStations;
      _stations = fetchedStations;
    } catch (e) {
      _error = 'Failed to load stations: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchStations(String query) {
    final keyword = query.trim().toLowerCase();

    if (keyword.isEmpty) {
      _stations = List.from(_allStations);
    } else {
      _stations = _allStations.where((station) {
        return station.name.toLowerCase().contains(keyword);
      }).toList();
    }

    notifyListeners();
  }

  void clearSearch() {
    _stations = List.from(_allStations);
    notifyListeners();
  }
}
