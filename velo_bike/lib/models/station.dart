class Station {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final int totalBikes;
  final int availableBikes;
  final String status;

  const Station({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.totalBikes,
    required this.availableBikes,
    required this.status,
  });
}
