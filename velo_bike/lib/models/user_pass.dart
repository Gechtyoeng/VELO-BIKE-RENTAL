class UserPass {
  final String id;
  final String userId;
  final String planId;
  final String status;
  final DateTime startDate;
  final DateTime endDate;

  final int totalRides; 
  final int usedRides; 

  const UserPass({
    required this.id,
    required this.userId,
    required this.planId,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.totalRides,
    required this.usedRides,
  });

  bool get isActive => status == 'active' && endDate.isAfter(DateTime.now()) && remainingRides > 0;

  bool get isExpired => DateTime.now().isAfter(endDate);

  int get remainingRides => totalRides - usedRides;
}
