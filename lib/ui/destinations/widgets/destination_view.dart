import 'package:flutter/material.dart';

import '../../core/brand_appbar.dart';
import '../view_models/destination_view_model.dart';

class DestinationView extends StatefulWidget {
  const DestinationView({required this.viewModelFactory, super.key});

  final DestinationViewModel Function() viewModelFactory;

  @override
  State<DestinationView> createState() => _DestinationViewState();
}

class _DestinationViewState extends State<DestinationView> {
  late final DestinationViewModel _viewModel = widget.viewModelFactory();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorscheme = theme.colorScheme;

    return Scaffold(
      // TODO: Replace with destination name
      appBar: brandAppbar(title: const Text("REPLACE_WITH_DESTINATION_NAME")),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            //
          ],
        ),
      ),
    );
  }
}
