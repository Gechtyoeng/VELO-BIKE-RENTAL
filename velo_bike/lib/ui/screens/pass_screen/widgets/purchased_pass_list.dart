import 'package:flutter/material.dart';
import 'package:velo_bike/ui/screens/pass_screen/viewmodel/pass_vm.dart';
import 'package:velo_bike/ui/screens/pass_screen/widgets/purchased_pass_card.dart';
import 'package:velo_bike/ui/theme/app_spacing.dart';

class PurchasedPassList extends StatelessWidget {
  final PassViewModel vm;
  const PurchasedPassList({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    final activePass = vm.activePass;
    final previousPasses = vm.previousPasses;
    final theme = Theme.of(context);
    if (activePass == null && previousPasses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.confirmation_number_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: AppSpacing.lg),
            const Text("No purchased pass", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: AppSpacing.sm),
            Text("Buy a pass to unlock bikes", style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
      );
    }

    return ListView(
      children: [
        if (activePass != null) ...[
          Text("Current Active Pass", style: theme.textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.md),
          PurchasedPassCard(userPass: activePass, planName: vm.getPlanNameById(activePass.planId)),
          const SizedBox(height: AppSpacing.xl),
        ],
        if (previousPasses.isNotEmpty) ...[
          Text("Previous Purchased Passes", style: theme.textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.md),
          ...previousPasses.map(
            (pass) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: PurchasedPassCard(userPass: pass, planName: vm.getPlanNameById(pass.planId)),
            ),
          ),
        ],
      ],
    );
  }
}
