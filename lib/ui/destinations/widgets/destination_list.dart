import 'package:flutter/material.dart';

import '../../core/brand_appbar.dart';
import '../view_models/destination_list_view_model.dart';

class DestinationList extends StatefulWidget {
  const DestinationList({required this.viewModelFactory, super.key});

  final DestinationListViewModel Function() viewModelFactory;

  @override
  State<DestinationList> createState() => _DestinationListState();
}

class _DestinationListState extends State<DestinationList> {
  late final DestinationListViewModel _viewModel = widget.viewModelFactory();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorscheme = theme.colorScheme;

    return Scaffold(
      appBar: brandAppbar(
        title: Text(_viewModel.isFavorite ? "Destinos Favoritos" : "Destinos"),
      ),
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
