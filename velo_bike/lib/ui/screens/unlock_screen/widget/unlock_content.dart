import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_bike/models/bike.dart';
import 'package:velo_bike/ui/states/auth_state.dart';
import '../viewmodel/unlock_vm.dart';

class UnlockContent extends StatelessWidget {
  const UnlockContent({super.key});

  @override
  Widget build(BuildContext context) {
    final bike =
        ModalRoute.of(context)!.settings.arguments as Bike;

    final vm = context.watch<UnlockViewModel>();

    //Auto back after success
    if (vm.status == UnlockStatus.success) {
      Future.delayed(const Duration(seconds: 1), () {
        if (context.mounted) Navigator.pop(context);
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Unlock Bike")),
      body: _buildBody(context, vm, bike),
    );
  }

  Widget _buildBody(
      BuildContext context, UnlockViewModel vm, Bike bike) {

    // Initial state
    if (vm.status == null) {
      return _buildInitial(context, vm, bike);
    }

    switch (vm.status!) {
      case UnlockStatus.loading:
        return const Center(child: CircularProgressIndicator());

      case UnlockStatus.success:
        return _buildResult(
          context,
          "Success",
          vm.message ?? "Bike unlocked",
          Colors.green,
        );

      case UnlockStatus.failure:
        return _buildResult(
          context,
          "Failed",
          vm.message ?? "Something went wrong",
          Colors.red,
        );
    }
  }

  Widget _buildInitial(
      BuildContext context, UnlockViewModel vm, Bike bike) {

    final user = context.read<AuthState>().currentUser!;

    return Center(
      child: ElevatedButton(
        onPressed: vm.status == UnlockStatus.loading
            ? null // to prevent spam click
            : () {
                vm.unlockBike(bike.id, user.id); 
              },
        child: const Text("Unlock Bike"),
      ),
    );
  }

  Widget _buildResult(
      BuildContext context, String title, String msg, Color color) {

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 22,
                  color: color,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(msg),
          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Back"),
          ),

          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Try Another Bike"),
          ),
        ],
      ),
    );
  }
}