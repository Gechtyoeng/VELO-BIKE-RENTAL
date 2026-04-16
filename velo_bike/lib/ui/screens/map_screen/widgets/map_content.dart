import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:velo_bike/ui/screens/map_screen/viewmodel/map_vm.dart';
import 'package:velo_bike/ui/theme/app_spacing.dart';

class MapContent extends StatelessWidget {
  const MapContent({super.key});

  Color _markerColor(int availableBikes) {
    if (availableBikes < 3) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MapViewModel>();

    if (vm.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (vm.error != null) {
      return Scaffold(body: Center(child: Text(vm.error!)));
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: FlutterMap(
          options: const MapOptions(
            initialCenter: LatLng(11.5564, 104.9282), // Phnom Penh
            initialZoom: 13,
          ),
          children: [
            TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'com.example.velo'),
            MarkerLayer(
              markers: vm.stations.map((station) {
                final isAvailable = vm.isStationAvailable(station);

                return Marker(
                  point: LatLng(station.latitude, station.longitude),
                  width: 80,
                  height: 80,
                  child: GestureDetector(
                    onTap: () {
                      if (!isAvailable) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No bikes available at this station')));
                        return;
                      }

                      // navigate to station detail
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.location_on, size: 36, color: isAvailable ? _markerColor(station.availableBikes) : Colors.grey),
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
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
