import 'package:flutter/material.dart';
import 'package:velo_bike/ui/screens/main_navigation_screen.dart';

class PassPurchaseSuccessDialog extends StatelessWidget {
  const PassPurchaseSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, size: 80, color: Colors.green),
            const SizedBox(height: 16),
            const Text('Purchase Successful!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Your pass is now active.\nYou can start unlocking bikes.', textAlign: TextAlign.center),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const MainNavigationScreen()), (route) => false);
                },
                child: const Text('Go to Map'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
