import 'package:flutter/material.dart';

class ActivePassWarningDialog extends StatelessWidget {
  const ActivePassWarningDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Active Pass Exists'),
      content: const Text('You already have an active pass.\n\nPlease use it or wait until it expires before buying a new one.'),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
    );
  }
}
