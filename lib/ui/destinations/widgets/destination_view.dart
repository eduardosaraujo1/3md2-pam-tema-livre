import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hot_tourist_destinations/routing/routes.dart';
import 'package:hot_tourist_destinations/ui/core/snackbar.dart';
import 'package:hot_tourist_destinations/ui/destinations/widgets/circular_flag.dart';

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

  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _viewModel.loadDestinationCommand.addListener(_onLoadChanged);
    _viewModel.saveDestinationInfoCommand.addListener(_onSaveChanged);
    _viewModel.loadDestinationCommand.execute();
  }

  @override
  void dispose() {
    _viewModel.loadDestinationCommand.removeListener(_onLoadChanged);
    _viewModel.saveDestinationInfoCommand.removeListener(_onSaveChanged);
    _notesController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _onLoadChanged() {
    if (!mounted) return;

    final value = _viewModel.loadDestinationCommand.value;
    if (value == null) return;

    if (value.isError()) {
      showErrorSnackbar(context, value.tryGetError()!);
    }
  }

  void _onSaveChanged() {
    if (!mounted) return;

    final value = _viewModel.saveDestinationInfoCommand.value;

    if (value == null) return;

    if (value.isError()) {
      showErrorSnackbar(context, value.tryGetError()!);
    }

    if (value.isSuccess()) {
      showSnackbar(context, "Informações salvas com sucesso!");
      context.go(Routes.destinations);
    }
  }

  void _save() {
    _viewModel.saveDestinationInfoCommand.execute(_notesController.text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorscheme = theme.colorScheme;

    return Scaffold(
      appBar: brandAppbar(
        title: const Text("Adicionar Observações"),
        onPop: () {
          context.go(Routes.destinations);
        },
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: ValueListenableBuilder(
          valueListenable: _viewModel.loadDestinationCommand,
          builder: (context, value, child) {
            if (value == null ||
                !_viewModel.loadDestinationCommand.canExecute.value) {
              return Center(child: CircularProgressIndicator());
            }

            if (value.isError()) {
              return Column(
                children: [
                  Icon(Icons.error, color: colorscheme.error, size: 48),
                  SizedBox(height: 12),
                  Text("Erro ao carregar o destino"),
                ],
              );
            }

            final destination = value.tryGetSuccess()!;
            _notesController.value = TextEditingValue(
              text: destination.userNotes,
            );

            return Column(
              spacing: 8,
              children: [
                ListTile(
                  title: Text(
                    destination.name,
                    style: theme.textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    destination.location,
                    style: theme.textTheme.bodyMedium,
                  ),
                  leading: CircularFlag(code: destination.countryCode),
                  tileColor: colorscheme.surfaceContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: colorscheme.outlineVariant),
                  ),
                ),

                TextField(
                  controller: _notesController,
                  maxLines: null,
                  decoration: InputDecoration(
                    labelText: "Observações",
                    hintText:
                        "Adicione suas observações sobre este destino\n\n",
                    border: OutlineInputBorder(),
                  ),
                ),

                ValueListenableBuilder(
                  valueListenable:
                      _viewModel.saveDestinationInfoCommand.canExecute,
                  builder: (context, canExecute, child) {
                    return Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton.icon(
                        onPressed: canExecute ? () => _save() : null,
                        icon: Icon(Icons.save),
                        label: Text("Salvar"),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
