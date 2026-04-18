class Ride {
  final String id;
  final String userId;
  final String bikeId;
  final String stationId;
  final DateTime startTime;
  final DateTime? endTime;
  final String status;

  const Ride({required this.id, required this.userId, required this.bikeId, required this.stationId, required this.startTime, this.endTime, required this.status});

  Ride copyWith({String? id, String? userId, String? bikeId, String? stationId, DateTime? startTime, DateTime? endTime, String? status}) {
    return Ride(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      bikeId: bikeId ?? this.bikeId,
      stationId: stationId ?? this.stationId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
    );
  }
}
