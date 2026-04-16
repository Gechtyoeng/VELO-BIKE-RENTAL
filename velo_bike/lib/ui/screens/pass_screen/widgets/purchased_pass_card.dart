import 'package:flutter/material.dart';
import 'package:velo_bike/models/user_pass.dart';
import 'package:velo_bike/ui/theme/app_colors.dart';
import 'package:velo_bike/ui/theme/app_spacing.dart';
import 'package:velo_bike/ui/utils/date_formatter.dart';

class PurchasedPassCard extends StatelessWidget {
  final UserPass userPass;
  final String planName;

  const PurchasedPassCard({super.key, required this.userPass, required this.planName});

  @override
  Widget build(BuildContext context) {
    final isActive = userPass.isActive;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ICON
          Container(
            width: 74,
            height: 74,
            decoration: BoxDecoration(color: isActive ? AppColors.primary : Colors.grey.shade400, shape: BoxShape.circle),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.pedal_bike, color: Colors.white, size: 26),
                SizedBox(height: 4),
                Text(
                  userPass.remainingRides.toString(),
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          /// CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// PASS NAME
                Text(
                  planName,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),

                const SizedBox(height: 8),

                /// REMAINING RIDES
                Text("Remaining: ${userPass.remainingRides} rides", style: const TextStyle(fontWeight: FontWeight.bold)),

                /// PROGRESSBAR
                if (isActive) ...[const SizedBox(height: 6), LinearProgressIndicator(value: userPass.totalRides == 0 ? 0 : userPass.usedRides / userPass.totalRides)],

                const SizedBox(height: 8),

                Text("Start: ${DateFormatter.formatDateTime(userPass.startDate)}"),
                const SizedBox(height: 4),
                Text("End: ${DateFormatter.formatDateTime(userPass.endDate)}"),

                const SizedBox(height: 8),

                /// STATUS BADGE
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: isActive ? Colors.green.shade100 : Colors.grey.shade200, borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    userPass.status,
                    style: TextStyle(color: isActive ? Colors.green.shade700 : Colors.grey.shade700, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
