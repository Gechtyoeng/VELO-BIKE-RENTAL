import 'package:flutter/material.dart';
import 'package:velo_bike/models/user_pass.dart';
import 'package:velo_bike/ui/theme/app_colors.dart';

class MapPassPanel extends StatelessWidget {
  final bool isExpanded;
  final UserPass? activePass;
  final VoidCallback onToggle;
  final VoidCallback onGetPassTap;

  const MapPassPanel({super.key, required this.isExpanded, required this.activePass, required this.onToggle, required this.onGetPassTap});

  @override
  Widget build(BuildContext context) {
    if (activePass == null) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOut,
        width: isExpanded ? 350 : 56,
        height: 56,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 10, offset: Offset(0, 3))],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(18),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: isExpanded
                  ? Padding(
                      key: const ValueKey('expanded-no-pass'),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.red, width: 1.5),
                            ),
                            child: const Icon(Icons.confirmation_number_outlined, color: Colors.grey, size: 16),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'No active pass',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            height: 30,
                            width: 80,
                            child: ElevatedButton(
                              onPressed: onGetPassTap,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                              ),
                              child: const Text('Get Pass'),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Center(
                      key: const ValueKey('collapsed-no-pass'),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.red, width: 1.5),
                        ),
                        child: const Icon(Icons.confirmation_number_outlined, color: Colors.grey, size: 18),
                      ),
                    ),
            ),
          ),
        ),
      );
    }

    final planName = activePass!.planId;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOut,
      width: isExpanded ? 300 : 56,
      height: 56,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 10, offset: Offset(0, 3))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(18),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: isExpanded
                ? Padding(
                    key: const ValueKey('expanded-pass'),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.pedal_bike, color: AppColors.primary, size: 12),
                              Text(
                                '${activePass!.remainingRides}',
                                style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.primary),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                planName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Remaining Ride: ${activePass!.remainingRides}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.chevron_right, color: Colors.white, size: 16),
                      ],
                    ),
                  )
                : Center(
                    key: const ValueKey('collapsed-pass'),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.pedal_bike, color: AppColors.primary, size: 13),
                          Text(
                            '${activePass!.remainingRides}',
                            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
