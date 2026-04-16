import 'package:velo_bike/models/user_pass.dart';

class UserPassDto {
  final String id;
  final String userId;
  final String planId;
  final String status;
  final DateTime startDate;
  final DateTime endDate;

  final int totalRides; 
  final int usedRides; 

  const UserPassDto({
    required this.id,
    required this.userId,
    required this.planId,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.totalRides,
    required this.usedRides,
  });

  factory UserPassDto.fromJson(String id, Map<String, dynamic> map) {
    return UserPassDto(
      id: id,
      userId: map['userId'] ?? '',
      planId: map['planId'] ?? '',
      status: map['status'] ?? 'expired',
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),

      totalRides: map['totalRides'] ?? 0,
      usedRides: map['usedRides'] ?? 0,
    );
  }

  UserPass toModel() {
    return UserPass(id: id, userId: userId, planId: planId, status: status, startDate: startDate, endDate: endDate, totalRides: totalRides, usedRides: usedRides);
  }
}
