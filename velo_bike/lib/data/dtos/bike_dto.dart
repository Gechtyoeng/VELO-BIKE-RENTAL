
import 'package:velo_bike/models/bike.dart';

class BikeDto {
  final String id;
  final String stationId;
  final String bikeCode;
  final String status;
  final int usedToday;

  const BikeDto({required this.id, required this.stationId, required this.bikeCode, required this.status, required this.usedToday});

  factory BikeDto.fromJson(String id, Map<String, dynamic> map) {
    return BikeDto(id: id, stationId: map['stationId'] ?? '', bikeCode: map['bikeCode'] ?? '', status: map['status'] ?? 'available', usedToday: map['usedToday'] ?? 0);
  }

  Bike toModel() {
    return Bike(id: id, stationId: stationId, bikeCode: bikeCode, status: status, usedToday: usedToday);
  }
}
