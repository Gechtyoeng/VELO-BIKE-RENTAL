class User {
  final String id;
  final String name;
  final String email;
  final String? activePassId;
  final String? currentReservationId;
  final String? currentRideId;

  const User({required this.id, required this.name, required this.email, this.activePassId, this.currentReservationId, this.currentRideId});
}
