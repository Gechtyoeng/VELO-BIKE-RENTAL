import 'package:flutter/material.dart';
import 'package:velo_bike/models/station.dart';
import 'package:velo_bike/ui/screens/station_screen/station_detail_screen.dart';

class StationMarker extends StatelessWidget {
  final Station station;
  final bool isAvailable;
  final VoidCallback onTapBackgroundClose;

  const StationMarker({super.key, required this.station, required this.isAvailable, required this.onTapBackgroundClose});

  Color markerColor(int availableBikes) {
    if (availableBikes < 3) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTapBackgroundClose();

        if (!isAvailable) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No bikes available at this station')));
          return;
        }

        Navigator.push(context, MaterialPageRoute(builder: (_) => StationDetailScreen(station: station)));
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_on, size: 36, color: isAvailable ? markerColor(station.availableBikes) : Colors.grey),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: isAvailable ? Colors.white : Colors.grey.shade300, borderRadius: BorderRadius.circular(8)),
            child: Text(
              '${station.availableBikes}',
              style: TextStyle(fontWeight: FontWeight.bold, color: isAvailable ? Colors.black : Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
