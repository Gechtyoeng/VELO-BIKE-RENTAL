import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/bike.dart';
import '../../unlock_screen/viewmodel/unlock_vm.dart';
import '../../../states/auth_state.dart';

class BikeDetailBottomSheet extends StatelessWidget {
  final Bike bike;

  const BikeDetailBottomSheet({super.key, required this.bike});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<UnlockViewModel>();

    switch (vm.status) {
      case UnlockStatus.idle:
        return _buildDetail(context, vm);

      case UnlockStatus.loading:
        return _buildLoading(context);

      case UnlockStatus.success:
        return _buildSuccess(context);

      case UnlockStatus.failure:
        return _buildFailure(context, vm);

      case UnlockStatus.noPass:
        return _buildNoPass(context);
    }
  }

  //main detail layout
  Widget _buildDetail(BuildContext context, UnlockViewModel vm) {
    final user = context.read<AuthState>().currentUser!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Bike ${bike.bikeCode}",
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close),
              )
            ],
          ),

          const SizedBox(height: 20),

          const Icon(Icons.pedal_bike, size: 80),

          const SizedBox(height: 20),

          //info
          _infoRow("Bike ID:", bike.bikeCode),
          const Divider(),

          _infoRow("Used Today:", "${bike.usedToday} Times",
              highlight: true),
          const Divider(),

          _infoRow(
            "Status:",
            bike.status == "available" ? "Free" : bike.status,
          ),

          const SizedBox(height: 30),

          //reserve button (not implemented)
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            onPressed: () {},
            child: const Text("Reserve"),
          ),

          const SizedBox(height: 12),

          /// ✅ FIXED UNLOCK BUTTON
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: () {
                /// 🚀 THIS IS THE IMPORTANT FIX
                vm.unlockBike(bike.id, user.id);
              },
              child: const Text("Unlock"),
            ),
          ),
        ],
      ),
    );
  }

  //loading layout
  Widget _buildLoading(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.pedal_bike, size: 80),
          const SizedBox(height: 20),

          LinearProgressIndicator(
            borderRadius: BorderRadius.circular(10),
            minHeight: 8,
          ),

          const SizedBox(height: 16),
          const Text("Unlocking your bike..."),

          const SizedBox(height: 30),

          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          )
        ],
      ),
    );
  }

  //success layout
  Widget _buildSuccess(BuildContext context) {
    return _resultLayout(
      context,
      icon: Icons.check_circle,
      color: Colors.green,
      title: "Bike unlocked successfully!",
      subtitle: "You're ready to ride.",
      buttonText: "Close",
      onPressed: () => Navigator.pop(context),
    );
  }

  //failure layout
  Widget _buildFailure(BuildContext context, UnlockViewModel vm) {
    return _resultLayout(
      context,
      icon: Icons.error,
      color: Colors.red,
      title: "Unlock Failed",
      subtitle: vm.message ?? "Try again",
      buttonText: "Try Again",
      onPressed: () => vm.reset(),
    );
  }

  //no active pass layout
  Widget _buildNoPass(BuildContext context) {
    return _resultLayout(
      context,
      icon: Icons.pedal_bike,
      color: Colors.grey,
      title: "No Active Pass",
      subtitle: "You need a pass to unlock a bike",
      buttonText: "Get Pass",
      onPressed: () {},
    );
  }

  // row for bike info
  Widget _infoRow(String label, String value,
      {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              color: highlight ? Colors.indigo : Colors.black,
              fontWeight: highlight
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  //result layout for success, failure, no pass
  Widget _resultLayout(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(20)),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 80),
          const SizedBox(height: 12),

          Text(
            title,
            style:
                const TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 6),
          Text(subtitle),

          const SizedBox(height: 30),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              backgroundColor: Colors.indigo,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(25),
              ),
            ),
            onPressed: onPressed,
            child: Text(buttonText),
          )
        ],
      ),
    );
  }
}