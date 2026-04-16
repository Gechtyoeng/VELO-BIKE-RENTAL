import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/station.dart';
import '../../../data/repositories/bikes/firebase_bike_repo.dart';
import 'viewmodel/station_detail_vm.dart';
import './widget/station_detail_content.dart';

class StationDetailScreen extends StatelessWidget {
  final Station station;

  const StationDetailScreen({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          StationDetailViewModel(FirebaseBikeRepo())
            ..loadBikes(station.id),
      child: StationDetailContent(station: station),
    );
  }
}