import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './viewmodel/unlock_vm.dart';
import './widget/unlock_content.dart';

class UnlockScreen extends StatelessWidget {
  const UnlockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return UnlockContent();
  }
}