import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hot_tourist_destinations/routing/routes.dart';

class BrandNavbar extends StatelessWidget {
  const BrandNavbar({this.currentIndex = 0, this.onTap, super.key});

  final void Function(int index)? onTap;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (index) {
        if (index == 0) {
          context.go(Routes.destinations);
        } else if (index == 1) {
          context.go(Routes.favorites);
        } else if (index == 2) {
          context.go(Routes.profile);
        }
      },
      currentIndex: currentIndex,
      items: [
        BottomNavigationBarItem(
          label: "Destinos",
          icon: Icon(Icons.book_outlined),
          activeIcon: Icon(Icons.book),
        ),
        BottomNavigationBarItem(
          label: "Favoritos",
          icon: Icon(Icons.star_outline),
          activeIcon: Icon(Icons.star),
        ),
        BottomNavigationBarItem(
          label: "Conta",
          icon: Icon(Icons.account_circle_outlined),
          activeIcon: Icon(Icons.account_circle),
        ),
      ],
    );
  }
}
