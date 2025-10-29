import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../routing/routes.dart';
import '../../core/brand_appbar.dart';
import '../../core/snackbar.dart';
import '../view_models/profile_view_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({required this.viewModelFactory, super.key});

  final ProfileViewModel Function() viewModelFactory;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileViewModel _viewModel = widget.viewModelFactory();

  @override
  void initState() {
    super.initState();
    _viewModel.loadProfileCommand.addListener(_onLoadProfileCommandChanged);
    _viewModel.loadProfileCommand.execute();
  }

  @override
  void dispose() {
    _viewModel.loadProfileCommand.removeListener(_onLoadProfileCommandChanged);
    _viewModel.dispose();
    super.dispose();
  }

  void _onLoadProfileCommandChanged() {
    final command = _viewModel.loadProfileCommand;

    // Initial value
    if (command.value == null) return;

    // Outside widget tree
    if (!mounted) return;

    final error = command.value!.tryGetError();
    if (error != null) {
      showErrorSnackbar(context, error);
    }
  }

  void _handleLogout() {
    _viewModel.logout();
    if (mounted) {
      context.go(Routes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: brandAppbar(title: const Text("Conta")),
      body: ValueListenableBuilder(
        valueListenable: _viewModel.loadProfileCommand,
        builder: (context, commandValue, child) {
          if (_viewModel.loadProfileCommand.isExecuting.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final profile = commandValue?.tryGetSuccess();
          if (profile == null) {
            return const Center(
              child: Text('Não foi possível carregar o perfil'),
            );
          }

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                // Profile Avatar
                CircleAvatar(
                  radius: 60,
                  backgroundColor: colorScheme.primaryContainer,
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 24),

                // Name Section
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Nome',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(profile.name, style: theme.textTheme.bodyLarge),
                ),
                const SizedBox(height: 16),

                // Email Section
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'E-mail',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(profile.email, style: theme.textTheme.bodyLarge),
                ),

                Divider(),

                // Logout Button
                ListTile(
                  leading: Icon(Icons.logout, color: colorScheme.error),
                  title: Text(
                    'Encerrar Sessão',
                    style: TextStyle(color: colorScheme.error),
                  ),
                  onTap: _handleLogout,
                  tileColor: colorScheme.errorContainer.withValues(alpha: 0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
