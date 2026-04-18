import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_bike/models/bike.dart';
import 'package:velo_bike/ui/screens/main_navigation_screen.dart';
import 'package:velo_bike/ui/screens/unlock_screen/viewmodel/unlock_vm.dart';
import 'package:velo_bike/ui/states/active_pass_state.dart';
import 'package:velo_bike/ui/widgets/action/velo_button.dart';

class UnlockContent extends StatelessWidget {
  final Bike bike;

  const UnlockContent({super.key, required this.bike});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<UnlockViewModel>();
    final activePassNotifier = context.watch<ActivePassNotifier>();
    final activePass = activePassNotifier.activePass;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Unlock Bike", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(padding: const EdgeInsets.all(16), child: _buildBody(context, vm, activePass)),
      ),
    );
  }

  Widget _buildBody(BuildContext context, UnlockViewModel vm, dynamic activePass) {
    if (vm.isLoading) {
      return _buildLoadingState();
    }

    if (vm.isSuccess) {
      return _buildSuccessState(context, vm);
    }

    if (vm.isNoPassState) {
      return _buildNoPassState(context, vm);
    }

    if (vm.isFailure) {
      return _buildFailureState(context, vm);
    }

    return _buildInitialState(context, vm, activePass);
  }

  Widget _buildInitialState(BuildContext context, UnlockViewModel vm, dynamic activePass) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Bike Details"),
        const SizedBox(height: 10),

        _buildInfoCard(children: [_buildInfoRow("Bike Code", bike.bikeCode), _buildInfoRow("Status", bike.status), _buildInfoRow("Bike ID", bike.id)]),

        const SizedBox(height: 20),

        _buildSectionTitle("Your Active Pass"),
        const SizedBox(height: 10),

        _buildInfoCard(
          children: [
            _buildInfoRow("Pass Status", activePass == null ? "No active pass" : activePass.status),
            _buildInfoRow("Remaining Rides", activePass == null ? "-" : "${activePass.remainingRides}"),
            _buildInfoRow("End Date", activePass == null ? "-" : _formatDate(activePass.endDate)),
          ],
        ),

        const Spacer(),

        PrimaryButton(text: "Confirm Unlock", onPressed: () => vm.unlockBike(bike.id)),
      ],
    );
  }

  Widget _buildSuccessState(BuildContext context, UnlockViewModel vm) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 90),
          const SizedBox(height: 16),
          const Text("Unlock Successful", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(vm.message ?? "Bike unlocked successfully", textAlign: TextAlign.center, style: const TextStyle(fontSize: 15)),
          const SizedBox(height: 24),

          PrimaryButton(
            text: "Back",
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MainNavigationScreen())),
          ),
        ],
      ),
    );
  }

  Widget _buildNoPassState(BuildContext context, UnlockViewModel vm) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.confirmation_num_outlined, color: Colors.orange, size: 90),
          const SizedBox(height: 16),
          const Text("No Active Pass", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(vm.message ?? "You need an active pass before unlocking a bike.", textAlign: TextAlign.center, style: const TextStyle(fontSize: 15)),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Back"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFailureState(BuildContext context, UnlockViewModel vm) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cancel, color: Colors.red, size: 90),
          const SizedBox(height: 16),
          const Text("Unlock Failed", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(vm.message ?? "Something went wrong.", textAlign: TextAlign.center, style: const TextStyle(fontSize: 15)),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: () {
                vm.reset();
              },
              child: const Text("Try Again"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.pedal_bike, size: 70, color: Colors.indigo),
          const SizedBox(height: 20),
          const Text("Unlocking bike...", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text(
            "Please wait while we prepare your ride.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 220,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: const LinearProgressIndicator(minHeight: 8, backgroundColor: Color(0xFFE0E0E0), valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
  }

  Widget _buildInfoCard({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text("$label:", style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
