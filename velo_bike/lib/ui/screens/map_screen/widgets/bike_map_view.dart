import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:velo_bike/models/station.dart';

import 'station_marker.dart';

class BikeMapView extends StatelessWidget {
  final List<Station> stations;
  final bool Function(Station station) isStationAvailable;
  final VoidCallback onBackgroundTap;
  final MapController mapController;

  const BikeMapView({super.key, required this.stations, required this.isStationAvailable, required this.onBackgroundTap, required this.mapController});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: const MapOptions(initialCenter: LatLng(11.5564, 104.9282), initialZoom: 13),
      children: [
        TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'com.example.velo'),
        MarkerLayer(
          markers: stations.map((station) {
            return Marker(
              point: LatLng(station.latitude, station.longitude),
              width: 80,
              height: 80,
              child: StationMarker(station: station, isAvailable: isStationAvailable(station), onTapBackgroundClose: onBackgroundTap),
            );
          }).toList(),
        ),
      ],
    );
  }
}
