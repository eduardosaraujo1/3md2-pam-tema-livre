import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hot_tourist_destinations/routing/routes.dart';

import 'brand_navbar.dart';

class ScaffoldWithNavbar extends StatelessWidget {
  const ScaffoldWithNavbar({
    super.key,
    required this.routerState,
    required this.body,
  });

  final GoRouterState routerState;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: BrandNavbar(currentIndex: _getCurrentIndex()),
    );
  }

  int _getCurrentIndex() {
    bool sWith(String s) => routerState.matchedLocation.startsWith(s);

    if (sWith(Routes.destinations)) return 0;
    if (sWith(Routes.favorites)) return 1;
    if (sWith(Routes.profile)) return 2;

    return 0;
  }
}
