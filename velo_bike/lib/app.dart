import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_bike/data/repositories/bikes/bike_repository.dart';
import 'package:velo_bike/data/repositories/bikes/firebase_bike_repo.dart';
import 'package:velo_bike/data/repositories/pass/firebase_pass_repo.dart';
import 'package:velo_bike/data/repositories/pass/pass_repository.dart';
import 'package:velo_bike/data/repositories/rides/firebaase_ride_repo.dart';
import 'package:velo_bike/data/repositories/rides/ride_ropository.dart';
import 'package:velo_bike/data/repositories/stations/firebase_station_repo.dart';
import 'package:velo_bike/data/repositories/stations/station_repository.dart';
import 'package:velo_bike/data/repositories/unlock/firebase_unlock_repo.dart';
import 'package:velo_bike/data/repositories/unlock/unlock_repository.dart';
import 'package:velo_bike/data/repositories/user/firebase_user_repo.dart';
import 'package:velo_bike/data/repositories/user/user_repository.dart';
import 'package:velo_bike/ui/screens/main_navigation_screen.dart';
import 'package:velo_bike/ui/states/active_pass_state.dart';
import 'package:velo_bike/ui/states/auth_state.dart';
import 'package:velo_bike/ui/theme/app_theme.dart';
import 'package:velo_bike/ui/screens/unlock_screen/viewmodel/unlock_vm.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //Repositories
        Provider<UserRepository>(create: (_) => FirebaseUserRepo()),
        Provider<StationRepository>(create: (_) => FirebaseStationRepo()),
        Provider<BikeRepository>(create: (_) => FirebaseBikeRepo()),
        Provider<PassRepository>(create: (_) => FirebasePassRepo()),
        Provider<RideRepository>(create: (_) => FirebaaseRideRepo()),
        Provider<UnlockRepository>(
          create: (context) => FirebaseUnlockRepo(
            userRepository: context.read<UserRepository>(),
            passRepository: context.read<PassRepository>(),
            bikeRepository: context.read<BikeRepository>(),
            stationRepository: context.read<StationRepository>(),
            rideRepository: context.read<RideRepository>(),
          ),
        ),
        //Global state
        ChangeNotifierProvider(create: (context) => AuthState(context.read<UserRepository>())..loadUser('user_001')),
        ChangeNotifierProvider(create: (_) => ActivePassNotifier()),

        ChangeNotifierProvider(create: (context) => UnlockViewModel(context.read<UnlockRepository>(), context.read<AuthState>(), context.read<ActivePassNotifier>())),
      ],
      child: MaterialApp(debugShowCheckedModeBanner: false, title: 'Velo', theme: AppTheme.lightTheme, home: AppStarter()),
    );
  }
}

class AppStarter extends StatelessWidget {
  const AppStarter({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<AuthState>();

    if (session.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (session.error != null) {
      return Scaffold(body: Center(child: Text(session.error!)));
    }

    if (session.currentUser == null) {
      return const Scaffold(body: Center(child: Text('User not found')));
    }

    return const MainNavigationScreen();
  }
}
