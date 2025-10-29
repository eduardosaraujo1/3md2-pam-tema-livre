import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../modules/auth/auth_module.dart';
import '../modules/destinations/destination_module.dart';
import '../ui/auth/view_models/login_view_model.dart';
import '../ui/auth/view_models/register_view_model.dart';
import '../ui/auth/widgets/login_screen.dart';
import '../ui/auth/widgets/register_screen.dart';
import '../ui/core/scaffold_with_navbar.dart';
import '../ui/destinations/view_models/destination_list_view_model.dart';
import '../ui/destinations/view_models/destination_view_model.dart';
import '../ui/destinations/widgets/destination_list.dart';
import '../ui/destinations/widgets/destination_view.dart';
import '../ui/profile/view_models/profile_view_model.dart';
import '../ui/profile/widgets/profile_screen.dart';
import 'routes.dart';

final _getIt = GetIt.I;

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final _shellRouteKey = GlobalKey<NavigatorState>();

final _goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  redirect: _redirectHandler,
  refreshListenable: _getIt<AuthModule>().profileNotifier,
  onException: (context, state, router) {
    router.go(Routes.home);
  },
  routes: [
    GoRoute(
      path: Routes.home,
      redirect: (context, state) => Routes.destinations,
    ),
    GoRoute(
      path: Routes.login,
      builder: (context, state) {
        final authModule = _getIt<AuthModule>();
        return LoginScreen(
          viewModelFactory: () => LoginViewModel(authModule: authModule),
        );
      },
    ),
    GoRoute(
      path: Routes.register,
      redirect: _redirectHandler,
      builder: (context, state) {
        final authModule = _getIt<AuthModule>();
        return RegisterScreen(
          viewModelFactory: () => RegisterViewModel(authModule: authModule),
        );
      },
    ),
    ShellRoute(
      navigatorKey: _shellRouteKey,
      builder: (context, state, child) {
        return ScaffoldWithNavbar(routerState: state, body: child);
      },
      routes: [
        GoRoute(
          path: Routes.destinations,
          builder: (context, state) {
            return DestinationList(
              viewModelFactory: () => DestinationListViewModel(
                destinationModule: _getIt(),
                favoritesOnly: false,
              ),
            );
          },
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) {
                final id = int.parse(state.pathParameters['id']!);
                return DestinationView(
                  viewModelFactory: () => DestinationViewModel(
                    id: id,
                    destinationModule: _getIt<DestinationModule>(),
                  ),
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: Routes.favorites,
          builder: (context, state) {
            return DestinationList(
              viewModelFactory: () => DestinationListViewModel(
                destinationModule: _getIt(),
                favoritesOnly: true,
              ),
            );
          },
        ),
        GoRoute(
          path: Routes.profile,
          builder: (context, state) {
            return ProfileScreen(
              viewModelFactory: () => ProfileViewModel(authModule: _getIt()),
            );
          },
        ),
      ],
    ),
  ],
);

Future<String?> _redirectHandler(
  BuildContext context,
  GoRouterState state,
) async {
  // Get current auth status from AuthModule
  final authModule = _getIt<AuthModule>();
  final isAuthenticated = authModule.profileNotifier.value != null;

  // If not authenticated and not in login or register route, redirect to login
  if (!isAuthenticated &&
      state.fullPath != Routes.login &&
      state.fullPath != Routes.register) {
    return Routes.login;
  }

  // If authenticated and in login or register route, redirect to home
  if (isAuthenticated &&
      (state.fullPath == Routes.login || state.fullPath == Routes.register)) {
    return Routes.home;
  }

  return null;
}

extension RoutingExtensions on BuildContext {
  GoRouter get router => _goRouter;
}
