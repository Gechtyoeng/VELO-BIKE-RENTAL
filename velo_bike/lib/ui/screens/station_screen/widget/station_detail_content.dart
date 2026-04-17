import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../models/station.dart';
import '../../../../models/bike.dart';
import '../viewmodel/station_detail_vm.dart';
import '../../../screens/unlock_screen/unlock_screen.dart';

class StationDetailContent extends StatelessWidget {
  final Station station;

  const StationDetailContent({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StationDetailViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(station.name, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _buildBody(context, vm),
    );
  }

  Widget _buildBody(BuildContext context, StationDetailViewModel vm) {
    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(vm.error!, textAlign: TextAlign.center),
        ),
      );
    }

    if (vm.bikes.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text("No available bikes at this station.", textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text("Found ${vm.bikes.length} available bikes", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ),

        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            itemCount: vm.bikes.length,
            itemBuilder: (context, index) {
              final bike = vm.bikes[index];
              return _buildBikeTile(context, bike, index, vm);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBikeTile(BuildContext context, Bike bike, int index, StationDetailViewModel vm) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.indigo,
            child: Text(
              "${index + 1}",
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(width: 12),

          // BIKE ICON
          const Icon(Icons.pedal_bike, size: 28, color: Colors.black87),

          const SizedBox(width: 12),

          // BIKE INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(bike.bikeCode, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text("Used today: ${bike.usedToday}", style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                Text(
                  bike.status,
                  style: TextStyle(fontSize: 12, color: bike.status == "available" ? Colors.green : Colors.red, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),

          // UNLOCK BUTTON
          SizedBox(
            height: 34,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: bike.status == "available"
                  ? () async {
                      await Navigator.push(context, MaterialPageRoute(builder: (_) => UnlockScreen(bike: bike)));

                      await vm.refresh();
                    }
                  : null,
              child: const Text("Unlock", style: TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }
}
