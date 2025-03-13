import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_parkingo/domain/blocs/auth/auth_bloc.dart';
import 'package:new_parkingo/domain/blocs/auth/auth_state.dart';
import 'package:new_parkingo/domain/blocs/location_permission/location_permission_bloc.dart';
import 'package:new_parkingo/domain/blocs/location_permission/location_permission_events.dart';
import 'package:new_parkingo/domain/blocs/location_permission/location_permission_state.dart';
import 'package:new_parkingo/domain/blocs/map/map_bloc.dart';
import 'package:new_parkingo/domain/blocs/map/map_event.dart';
import 'package:new_parkingo/domain/blocs/map/map_state.dart';
import 'package:new_parkingo/presentation/widgets/custom_circular_progress.dart';
import 'package:new_parkingo/presentation/widgets/home_page_layout.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider<MapBloc>(
            create: (context) => MapBloc(),
          ),
          BlocProvider<LocationPermissionBloc>(
            create: (context) =>
                LocationPermissionBloc()..add(CheckPermission()),
          ),
        ],
        child: MultiBlocListener(
            listeners: [
              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  // Handle AuthBloc changes if needed
                },
              ),
              BlocListener<LocationPermissionBloc, LocationPermissionState>(
                listener: (context, state) {
                  if (state is PermissionDenied) {
                    // Show Android permission popup
                    context
                        .read<LocationPermissionBloc>()
                        .add(RequestPermission());
                  } else if (state is PermissionGranted) {
                    context.read<MapBloc>().add(LoadMap());
                  } else if (state is PermissionDeniedForever) {
                    // Suggest the user open settings to enable permission
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Please enable location permission from settings')),
                    );
                  }
                },
              )
            ],
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authstate) {
                if (authstate is AuthAuthenticated) {
                  final String userId = authstate.user.uid;
                  return BlocBuilder<MapBloc, MapState>(
                    builder: (context, state) {
                      if (state is MapLoading) {
                        debugPrint("State is $state");
                        return const Center(child: CustomCircularProgress());
                      } else if (state is MapLoaded) {
                        debugPrint("State is $state");
                        return HomePageLayout(
                          latitude: state.latitude,
                          longitude: state.longitude,
                          userId: userId,
                        );
                      } else if (state is MapError) {
                        debugPrint("State is $state");
                        return Center(child: Text('Error: ${state.message}'));
                      } else {
                        debugPrint("State is $state");
                        return const Center(child: Text('Loading Map...'));
                      }
                    },
                  );
                } else {
                  return const Center(
                    child: Text("User not Authenticated"),
                  );
                }
              },
            )),
      ),
    );
  }
}
