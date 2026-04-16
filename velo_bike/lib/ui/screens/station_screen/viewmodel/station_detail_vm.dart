import 'package:flutter/material.dart';
import '../../../../data/repositories/bikes/bike_repository.dart';
import '../../../../models/bike.dart';

class StationDetailViewModel extends ChangeNotifier {
  final BikeRepository bikeRepository;

  StationDetailViewModel(this.bikeRepository);

  List<Bike> bikes = [];
  bool isLoading = false;
  String? error;

  Future<void> loadBikes(String stationId) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final allBikes =
          await bikeRepository.getBikesByStation(stationId);

      bikes = allBikes
          .where((b) => b.status == "available")
          .toList();

      if (bikes.isEmpty) {
        error = "No available bikes";
      }

    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}