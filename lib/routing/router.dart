import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../modules/auth/auth_module.dart';
import '../ui/auth/view_models/login_view_model.dart';
import '../ui/auth/view_models/register_view_model.dart';
import '../ui/auth/widgets/login_screen.dart';
import '../ui/auth/widgets/register_screen.dart';
import 'routes.dart';

final _getIt = GetIt.I;

final _goRouter = GoRouter(
  redirect: _redirectHandler,
  refreshListenable: _getIt<AuthModule>().tokenNotifier,
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
    GoRoute(
      path: Routes.destinations,
      builder: (context, state) {
        final authModule = _getIt<AuthModule>();
        final user = authModule.getProfile();
        return Scaffold(
          body: Center(
            child: FutureBuilder(
              future: user,
              builder: (context, val) {
                if (val.hasError) return Text(val.error.toString());
                if (!val.hasData) return CircularProgressIndicator();

                return Text(
                  val.data?.tryGetSuccess()?.toString() ?? "User Not Found",
                );
              },
            ),
          ),
        );
      },
    ),
  ],
);

Future<String?> _redirectHandler(
  BuildContext context,
  GoRouterState state,
) async {
  // Get current auth status from AuthModule
  final authModule = _getIt<AuthModule>();
  final isAuthenticated = authModule.tokenNotifier.value != null;

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
