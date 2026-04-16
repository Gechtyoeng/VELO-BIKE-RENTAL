import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_bike/data/repositories/stations/station_repository.dart';
import 'package:velo_bike/ui/screens/map_screen/viewmodel/map_vm.dart';
import 'package:velo_bike/ui/screens/map_screen/widgets/map_content.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
   return ChangeNotifierProvider(
      create: (context) => MapViewModel(
        context.read<StationRepository>(),
      )..loadStations(),
      child: const MapContent(),
    );
  }
}