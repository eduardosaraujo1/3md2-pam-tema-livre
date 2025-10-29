import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../routing/routes.dart';
import '../../core/brand_appbar.dart';
import '../../core/snackbar.dart';
import '../view_models/destination_list_view_model.dart';
import 'destination_card.dart';

class DestinationList extends StatefulWidget {
  const DestinationList({required this.viewModelFactory, super.key});

  final DestinationListViewModel Function() viewModelFactory;

  @override
  State<DestinationList> createState() => _DestinationListState();
}

class _DestinationListState extends State<DestinationList> {
  late final DestinationListViewModel _viewModel = widget.viewModelFactory();

  @override
  void initState() {
    super.initState();

    _viewModel.loadDestinationsCommand.addListener(_onLoadChanged);
    _viewModel.loadDestinationsCommand.execute();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _onLoadChanged() {
    if (!mounted) return;

    final value = _viewModel.loadDestinationsCommand.value;
    if (value == null) return;

    if (value.isError()) {
      showErrorSnackbar(context, value.tryGetError()!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorscheme = theme.colorScheme;

    return Scaffold(
      appBar: brandAppbar(
        title: Text(_viewModel.isFavorite ? "Destinos Favoritos" : "Destinos"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _viewModel.loadDestinationsCommand.execute();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: ValueListenableBuilder(
            valueListenable: _viewModel.loadDestinationsCommand,
            builder: (context, value, child) {
              final command = _viewModel.loadDestinationsCommand;
              if (value == null || !command.canExecute.value) {
                return Center(
                  child: CircularProgressIndicator(color: colorscheme.primary),
                );
              }

              if (value.isError()) {
                return Center(
                  child: Text(
                    'Ocorreu um erro ao carregar os destinos.',
                    style: theme.textTheme.bodyLarge,
                  ),
                );
              }

              final destinations = value.tryGetSuccess()!;

              if (destinations.isEmpty) {
                return Center(
                  child: Text(
                    'Nenhum destino encontrado.',
                    style: theme.textTheme.bodyLarge,
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: destinations.length,
                itemBuilder: (context, index) {
                  final destination = destinations[index];
                  return DestinationCard(
                    destination: destination,
                    onTapFavorite: () {
                      // Toggle favorite status
                      _viewModel.markFavorite(
                        destination.id,
                        !destination.isFavorite,
                      );
                    },
                    onTapEdit: () {
                      // Handle edit observations
                      context.go(Routes.destination(destination.id));
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
