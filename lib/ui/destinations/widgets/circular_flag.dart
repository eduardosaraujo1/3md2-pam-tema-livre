import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

class CircularFlag extends StatelessWidget {
  const CircularFlag({super.key, required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ClipOval(
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(color: colorScheme.surfaceContainerHigh),
        child: FittedBox(
          fit: BoxFit.cover,
          child: CountryFlag.fromCountryCode(code),
        ),
      ),
    );
  }
}
