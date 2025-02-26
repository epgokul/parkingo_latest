import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:new_parkingo/domain/blocs/add_spot/add_spot_bloc.dart';
import 'package:new_parkingo/domain/blocs/auth/auth_bloc.dart';
import 'package:new_parkingo/domain/blocs/auth/auth_event.dart';
import 'package:new_parkingo/domain/blocs/auth/auth_state.dart';
import 'package:new_parkingo/domain/blocs/land_decision/land_decision_bloc.dart';
import 'package:new_parkingo/domain/blocs/location_permission/location_permission_bloc.dart';
import 'package:new_parkingo/domain/blocs/map/map_bloc.dart';
import 'package:new_parkingo/domain/blocs/navigation/navigation_bloc.dart';
import 'package:new_parkingo/presentation/screens/Admin/admin_home_page.dart';
import 'package:new_parkingo/presentation/screens/home_page.dart';
import 'package:new_parkingo/presentation/screens/onboarding_page.dart';
import 'package:new_parkingo/presentation/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox('userBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc()..add(CheckAuthStatusEvent()),
          ),
          BlocProvider<MapBloc>(
            create: (context) => MapBloc(),
          ),
          BlocProvider<LocationPermissionBloc>(
            create: (context) => LocationPermissionBloc(),
          ),
          BlocProvider<NavigationBloc>(
            create: (context) => NavigationBloc(),
          ),
          BlocProvider<AddSpotBloc>(
            create: (context) => AddSpotBloc(),
          ),
          BlocProvider<LandDecisionBloc>(
            create: (context) => LandDecisionBloc(),
          )
        ],
        child: MaterialApp(
          home: const AuthWrapper(),
          theme: Parkingotheme.lightTheme,
          darkTheme: Parkingotheme.darkTheme,
          themeMode: ThemeMode.system,
          debugShowCheckedModeBanner: false,
        ));
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        debugPrint("current state: $state");
        if (state is AuthInitial || state is AuthLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AuthAuthenticated) {
          return const HomePage();
        } else if (state is AuthAuthenticatedAdmin) {
          return const AdminHomePage();
        } else if (state is UnAuthenticated) {
          return const OnboardingPage();
        } else {
          // Handle unexpected state
          return const Center(child: Text('Unexpected error occurred'));
        }
      },
    );
  }
}
