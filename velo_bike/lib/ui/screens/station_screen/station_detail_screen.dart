import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/station.dart';
import 'package:velo_bike/data/repositories/bikes/bike_repository.dart';
import 'viewmodel/station_detail_vm.dart';
import './widget/station_detail_content.dart';

class StationDetailScreen extends StatelessWidget {
  final Station station;

  const StationDetailScreen({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final vm = StationDetailViewModel(
          context.read<BikeRepository>(), //use Provider
        );

        vm.loadBikes(station.id); //load here

        return vm;
      },
      child: StationDetailContent(station: station),
    );
  }
}