import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/station.dart';
import '../../../models/bike.dart';
import '../../../data/repositories/bikes/firebase_bike_repo.dart';
import 'viewmodel/station_detail_vm.dart';

class StationDetailScreen extends StatelessWidget {
  
  final Station station;

  const StationDetailScreen({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          StationDetailViewModel(FirebaseBikeRepo())
            ..loadBikes(station.id),
      child: Scaffold(
        appBar: AppBar(
          title: Text(station.name),
        ),
        body: Consumer<StationDetailViewModel>(
          builder: (context, vm, _) {

            //Loading
            if (vm.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            //Error
            if (vm.error != null) {
              return Center(child: Text(vm.error!));
            }

            //Data
            return Column(
              children: [

                // Station Info
                _buildStationInfo(),

                //Bike List
                Expanded(
                  child: ListView.builder(
                    itemCount: vm.bikes.length,
                    itemBuilder: (context, index) {
                      final bike = vm.bikes[index];
                      return _buildBikeCard(context, bike);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  //Station Info Card
  Widget _buildStationInfo() {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              station.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text("Total Bikes: ${station.totalBikes}"),
            Text("Available Bikes: ${station.availableBikes}"),
          ],
        ),
      ),
    );
  }

  //Bike Card
  Widget _buildBikeCard(BuildContext context, Bike bike) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text("Bike Code: ${bike.bikeCode}"),
        subtitle: Text("Used Today: ${bike.usedToday}"),

        trailing: ElevatedButton(
          child: const Text("Unlock"),
          onPressed: () {
            _onUnlock(context, bike);
          },
        ),
      ),
    );
  }

  // Navigate to Unlock Screen
  void _onUnlock(BuildContext context, Bike bike) {
    Navigator.pushNamed(
      context,
      '/unlock',
      arguments: bike,
    );
  }
}