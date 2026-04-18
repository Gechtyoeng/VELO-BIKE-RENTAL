import 'package:flutter/material.dart';
import 'package:velo_bike/models/station.dart';
import 'package:velo_bike/ui/screens/station_screen/station_detail_screen.dart';

class SearchSuggestionList extends StatelessWidget {
  final List<Station> stations;
  final ValueChanged<Station> onSelect;

  const SearchSuggestionList({super.key, required this.stations, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    if (stations.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 8)],
        ),
        child: const Text('No station found', textAlign: TextAlign.center),
      );
    }

    return Container(
      margin: const EdgeInsets.only(top: 8),
      constraints: const BoxConstraints(maxHeight: 220),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 10)],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: stations.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final station = stations[index];
          return ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: Text(station.name, maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text('${station.availableBikes} bikes available'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => StationDetailScreen(station: station))),
          );
        },
      ),
    );
  }
}
