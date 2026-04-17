import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_bike/data/repositories/unlock/unlock_repository.dart';
import 'package:velo_bike/models/bike.dart';
import 'package:velo_bike/ui/screens/unlock_screen/viewmodel/unlock_vm.dart';
import 'package:velo_bike/ui/screens/unlock_screen/widgets/unlock_content.dart';
import 'package:velo_bike/ui/states/active_pass_state.dart';
import 'package:velo_bike/ui/states/auth_state.dart';

class UnlockScreen extends StatelessWidget {
  final Bike bike;

  const UnlockScreen({super.key, required this.bike});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UnlockViewModel(context.read<UnlockRepository>(), context.read<AuthState>(), context.read<ActivePassNotifier>()),
      child: UnlockContent(bike: bike),
    );
  }
}
