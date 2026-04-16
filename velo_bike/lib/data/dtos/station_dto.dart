import 'package:velo_bike/models/station.dart';

class StationDto {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final int totalBikes;
  final int availableBikes;
  final String status;

  const StationDto({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.totalBikes,
    required this.availableBikes,
    required this.status,
  });

  factory StationDto.fromJson(String id, Map<String, dynamic> map) {
    return StationDto(
      id: id,
      name: map['name'] ?? '',
      latitude: (map['latitude'] ?? 0).toDouble(),
      longitude: (map['longitude'] ?? 0).toDouble(),
      totalBikes: map['totalBikes'] ?? 0,
      availableBikes: map['availableBikes'] ?? 0,
      status: map['status'] ?? 'open',
    );
  }

  Station toModel() {
    return Station(id: id, name: name, latitude: latitude, longitude: longitude, totalBikes: totalBikes, availableBikes: availableBikes, status: status);
  }
}
