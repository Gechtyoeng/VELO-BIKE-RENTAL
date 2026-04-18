import '../../models/ride.dart';

class RideDto {
  final String id;
  final String userId;
  final String bikeId;
  final String stationId;
  final String startTime;
  final String? endTime;
  final String status;

  RideDto({required this.id, required this.userId, required this.bikeId, required this.stationId, required this.startTime, this.endTime, required this.status});

  factory RideDto.fromJson(String id, Map<String, dynamic> json) {
    return RideDto(
      id: id,
      userId: json['userId'] ?? '',
      bikeId: json['bikeId'] ?? '',
      stationId: json['stationId'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'],
      status: json['status'] ?? 'ongoing',
    );
  }

  Ride toModel() {
    return Ride(
      id: id,
      userId: userId,
      bikeId: bikeId,
      stationId: stationId,
      startTime: DateTime.parse(startTime),
      endTime: endTime != null ? DateTime.tryParse(endTime!) : null,
      status: status,
    );
  }

  Map<String, dynamic> toJson() {
    return {'userId': userId, 'bikeId': bikeId, 'stationId': stationId, 'startTime': startTime, 'endTime': endTime, 'status': status};
  }
}
