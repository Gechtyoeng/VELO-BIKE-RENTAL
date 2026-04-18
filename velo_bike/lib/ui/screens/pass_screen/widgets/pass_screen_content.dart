import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_bike/ui/screens/pass_screen/viewmodel/pass_vm.dart';
import 'package:velo_bike/ui/screens/pass_screen/widgets/pass_plan_card.dart';
import 'package:velo_bike/ui/screens/pass_screen/widgets/pass_purchase_dialog.dart';
import 'package:velo_bike/ui/screens/pass_screen/widgets/pass_warning_dialog.dart';
import 'package:velo_bike/ui/screens/pass_screen/widgets/purchased_pass_list.dart';
import 'package:velo_bike/ui/theme/app_colors.dart';
import 'package:velo_bike/ui/theme/app_spacing.dart';
import 'package:velo_bike/ui/widgets/action/velo_button.dart';

class PassScreenContent extends StatefulWidget {
  const PassScreenContent({super.key});

  @override
  State<PassScreenContent> createState() => _PassScreenContentState();
}

class _PassScreenContentState extends State<PassScreenContent> {
  int tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PassViewModel>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text("Choose Your Pass", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 4),
              const Text("Unlock bikes anytime, anywhere"),
              const SizedBox(height: 20),
              _buildTabs(),
              const SizedBox(height: 20),
              Expanded(child: tabIndex == 0 ? _buildAvailable(vm) : PurchasedPassList(vm: vm)),
              if (tabIndex == 0) _buildBuyButton(vm, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(30)),
      child: Row(children: [_tabItem("Available Pass", 0), _tabItem("My Purchased", 1)]),
    );
  }

  Widget _tabItem(String text, int index) {
    final isSelected = tabIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => tabIndex = index);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(color: isSelected ? AppColors.primary : Colors.transparent, borderRadius: BorderRadius.circular(30)),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(color: isSelected ? Colors.white : Colors.grey, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}

Widget _buildAvailable(PassViewModel vm) {
  return ListView.separated(
    itemCount: vm.plans.length,
    separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.lg),
    itemBuilder: (context, index) {
      final plan = vm.plans[index];
      final isSelected = vm.selectedPlan?.id == plan.id;

      return GestureDetector(
        onTap: () => vm.selectPlan(plan),
        child: PassPlanCard(plan: plan, isSelected: isSelected),
      );
    },
  );
}

Widget _buildBuyButton(PassViewModel vm, BuildContext context) {
  return Container(
    margin: const EdgeInsets.only(top: 16),
    child: PrimaryButton(
      text: "Buy Now",
      isLoading: vm.isLoading,
      onPressed: vm.selectedPlan == null
          ? null
          : () async {
              if (vm.hasUsableActivePass) {
                showDialog(context: context, builder: (_) => const ActivePassWarningDialog());
                return;
              }

              await vm.buyPlan();

              if (!context.mounted) return;

              if (vm.isSuccess) {
                showDialog(context: context, barrierDismissible: false, builder: (_) => const PassPurchaseSuccessDialog());
                vm.resetSuccess();
                return;
              }
            },
    ),
  );
}
