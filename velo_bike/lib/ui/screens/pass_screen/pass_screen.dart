import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_bike/data/repositories/pass/pass_repository.dart';
import 'package:velo_bike/ui/screens/pass_screen/viewmodel/pass_vm.dart';
import 'package:velo_bike/ui/screens/pass_screen/widgets/pass_screen_content.dart';
import 'package:velo_bike/ui/states/active_pass_state.dart';
import 'package:velo_bike/ui/states/auth_state.dart';

class PassScreen extends StatelessWidget {
  const PassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PassViewModel(context.read<AuthState>(), context.read<PassRepository>(), context.read<ActivePassNotifier>())..loadPassData(),
      child: const PassScreenContent(),
    );
  }
}
