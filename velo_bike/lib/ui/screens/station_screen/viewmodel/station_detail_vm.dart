import 'package:flutter/material.dart';
import '../../../../data/repositories/bikes/bike_repository.dart';
import '../../../../models/bike.dart';

class StationDetailViewModel extends ChangeNotifier {
  final BikeRepository bikeRepository;

  StationDetailViewModel(this.bikeRepository);

  List<Bike> bikes = [];
  bool isLoading = false;
  String? error;
  String? _stationId;

  Future<void> loadBikes(String stationId) async {
    _stationId = stationId;

    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final allBikes = await bikeRepository.getBikesByStation(stationId);
      bikes = allBikes.where((bike) => bike.status == "available").toList();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    if (_stationId != null) {
      await loadBikes(_stationId!);
    }
  }
}
