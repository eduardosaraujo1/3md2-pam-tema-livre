import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../routing/routes.dart';
import '../../core/snackbar.dart';
import '../view_models/login_view_model.dart';
import 'layout/login_decorator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({required this.viewModelFactory, super.key});

  final LoginViewModel Function() viewModelFactory;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late final LoginViewModel _viewModel = widget.viewModelFactory();

  @override
  void initState() {
    super.initState();

    _viewModel.loginCommand.addListener(_onLoginCommandChanged);
  }

  @override
  void dispose() {
    _viewModel.loginCommand.removeListener(_onLoginCommandChanged);

    _emailController.dispose();
    _passwordController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _onLoginCommandChanged() {
    final command = _viewModel.loginCommand;

    // Initial value
    if (command.value == null) return;

    // Outside widget tree
    if (!mounted) return;

    final (:success, :error) = command.value!.getBoth();

    if (error != null) {
      showErrorSnackbar(context, error.toString());
      return;
    }

    // Successful login: navigate to home screen
    context.go(Routes.home);
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira seu e-mail';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Por favor, insira um e-mail válido';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira sua senha';
    }
    return null;
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      _viewModel.loginCommand.execute(
        LoginData(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LoginDecorator(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Headline
              Text(
                'Iniciar sessão',
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),

              // Email field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
              ),

              // Password field
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: _validatePassword,
              ),
              // Login button
              ValueListenableBuilder(
                valueListenable: _viewModel.loginCommand.canExecute,
                builder: (context, canExecute, child) {
                  return Column(
                    spacing: 4,
                    children: [
                      FilledButton(
                        onPressed: canExecute ? _handleLogin : null,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Text('Entrar'),
                        ),
                      ),
                      // Sign up text
                      TextButton(
                        onPressed: canExecute
                            ? () {
                                context.go(Routes.register);
                              }
                            : null,
                        child: Text(
                          'Não tem uma conta? Cadastre-se',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      if (_viewModel.loginCommand.isExecuting.value)
                        const CircularProgressIndicator(),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
