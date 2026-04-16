import 'package:flutter/material.dart';
import 'package:velo_bike/models/pass_plan.dart';
import 'package:velo_bike/ui/theme/app_colors.dart';

class PassPlanCard extends StatelessWidget {
  final PassPlan plan;
  final bool isSelected;
  const PassPlanCard({super.key, required this.plan, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: isSelected ? AppColors.primary : Colors.transparent, width: 2),
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Row(
        children: [
          /// Circle icon
          Container(
            width: 74,
            height: 74,
            decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.pedal_bike, color: Colors.white, size: 26),
                const SizedBox(height: 4),
                Text(
                  plan.durationDays.toString(),
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          /// Info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(plan.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text("Price: \$${plan.price}"),
              Text("Duration: ${plan.durationDays} days"),
            ],
          ),
        ],
      ),
    );
  }
}
