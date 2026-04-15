import 'package:velo_bike/models/user.dart';

class UserDto {
  final String id;
  final String name;
  final String email;
  final String? activePassId;
  final String? currentReservationId;
  final String? currentRideId;

  const UserDto({required this.id, required this.name, required this.email, this.activePassId, this.currentReservationId, this.currentRideId});

  // From json data
  factory UserDto.fromJson(String id, Map<String, dynamic> json) {
    return UserDto(
      id: id,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      activePassId: json['activePassId'],
      currentReservationId: json['currentReservationId'],
      currentRideId: json['currentRideId'],
    );
  }

  // To json
  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'activePassId': activePassId, 'currentReservationId': currentReservationId, 'currentRideId': currentRideId};
  }

  // To model
  User toModel() {
    return User(id: id, name: name, email: email, activePassId: activePassId, currentReservationId: currentReservationId, currentRideId: currentRideId);
  }
}
