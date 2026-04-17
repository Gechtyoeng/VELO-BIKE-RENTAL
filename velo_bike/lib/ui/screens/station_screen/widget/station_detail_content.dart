import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/station.dart';
import '../../../../models/bike.dart';
import '../viewmodel/station_detail_vm.dart';

class StationDetailContent extends StatelessWidget {
  final Station station;

  const StationDetailContent({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StationDetailViewModel>();

    return Scaffold(
      appBar: AppBar(title: Text(station.name)),
      body: _buildBody(context, vm),
    );
  }

  Widget _buildBody(BuildContext context, StationDetailViewModel vm) {
    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.error != null) {
      return Center(child: Text(vm.error!));
    }

    return Column(
      children: [
        _buildStationInfo(),
        Expanded(child: _buildBikeList(vm)),
      ],
    );
  }

  Widget _buildStationInfo() {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(station.name,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Total Bikes: ${station.totalBikes}"),
            Text("Available Bikes: ${station.availableBikes}"),
          ],
        ),
      ),
    );
  }

  Widget _buildBikeList(StationDetailViewModel vm) {
    return ListView.builder(
      itemCount: vm.bikes.length,
      itemBuilder: (context, index) {
        final bike = vm.bikes[index];
        return _buildBikeCard(context, bike);
      },
    );
  }

  Widget _buildBikeCard(BuildContext context, Bike bike) {
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    child: ListTile(
      title: Text("Bike Code: ${bike.bikeCode}"),
      subtitle: Text("Used Today: ${bike.usedToday}"),

      trailing: SizedBox(
        width: 90, 
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/unlock',
              arguments: bike,
            );
          },
          child: const Text(
            "Unlock",
            overflow: TextOverflow.ellipsis, // prevent overflow
          ),
        ),
      ),
    ),
  );
}
}