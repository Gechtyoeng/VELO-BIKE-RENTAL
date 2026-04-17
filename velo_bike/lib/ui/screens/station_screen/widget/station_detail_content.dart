import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/station.dart';
import '../../../../models/bike.dart';
import '../viewmodel/station_detail_vm.dart';
import '../../unlock_screen/viewmodel/unlock_vm.dart';
import './bike_detail_bottom_sheet.dart';

class StationDetailContent extends StatelessWidget {
  final Station station;

  const StationDetailContent({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StationDetailViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(station.name),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),

      body: _buildBody(context, vm),
    );
  }

  //main body state handler
  Widget _buildBody(BuildContext context, StationDetailViewModel vm) {
    // Loading state
    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    //Error state
    if (vm.error != null) {
      return Center(child: Text(vm.error!));
    }

    
    return Column(
      children: [

        //bike found count
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Founded ${vm.bikes.length} bikes:",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ),

        /// Bike list
        Expanded(child: _buildBikeList(vm)),
      ],
    );
  }

  

  //bike list widget
  Widget _buildBikeList(StationDetailViewModel vm) {
    return ListView.builder(
      itemCount: vm.bikes.length,
      itemBuilder: (context, index) {
        final bike = vm.bikes[index];

        // Pass index for numbering
        return _buildBikeCard(context, bike, index);
      },
    );
  }

  //single bike card widget
  Widget _buildBikeCard(BuildContext context, Bike bike, int index) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

          // Main row layout
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              // Bike number badge
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    "${index + 1}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Bike icon and bike code
              Column(
                children: [
                  const Icon(Icons.pedal_bike, size: 28),
                  Text(
                    bike.bikeCode,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),

              const SizedBox(width: 16),

              

              //unlock button
              SizedBox(
                width: 100,
                height: 38,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    padding: EdgeInsets.zero, 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) {
                        return ChangeNotifierProvider(
                          create: (_) => UnlockViewModel(context.read()),
                          child: FractionallySizedBox(
                            heightFactor: 0.75,
                            child: BikeDetailBottomSheet(bike: bike),
                          ),
                        );
                      },
                    );
                  },
                  child: const Text(
                    "Unlock",
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              )
            ],
          ),
        ),

        const Divider(indent: 52, thickness: 1),
      ],
    );
  }
}