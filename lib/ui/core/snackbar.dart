import 'package:flutter/material.dart';

ScaffoldFeatureController showSnackbar(BuildContext context, String message) {
  return ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message)));
}

ScaffoldFeatureController showErrorSnackbar(
  BuildContext context,
  String message,
) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Theme.of(context).colorScheme.error,
    ),
  );
}
