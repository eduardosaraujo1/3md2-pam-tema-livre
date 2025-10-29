import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../modules/auth/auth_module.dart';
import '../ui/auth/view_models/login_view_model.dart';
import '../ui/auth/view_models/register_view_model.dart';
import '../ui/auth/widgets/login_screen.dart';
import '../ui/auth/widgets/register_screen.dart';
import '../ui/core/scaffold_with_navbar.dart';
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
            return Placeholder();
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
