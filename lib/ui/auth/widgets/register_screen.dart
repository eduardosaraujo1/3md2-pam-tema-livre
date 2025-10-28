import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hot_tourist_destinations/routing/routes.dart';
import 'package:hot_tourist_destinations/ui/auth/view_models/register_view_model.dart';
import 'package:hot_tourist_destinations/ui/auth/widgets/layout/login_decorator.dart';
import 'package:hot_tourist_destinations/ui/core/snackbar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({required this.viewModelFactory, super.key});

  final RegisterViewModel Function() viewModelFactory;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final RegisterViewModel _viewModel = widget.viewModelFactory();
  final controller = _FormController();

  void _handleRegister() {
    if (controller.validate()) {
      final formData = RegisterFormData(
        name: controller.nameController.text,
        email: controller.emailController.text,
        password: controller.passwordController.text,
        confirmPassword: controller.confirmPasswordController.text,
      );
      _viewModel.registerCommand.execute(formData);
    }
  }

  @override
  void initState() {
    super.initState();
    _viewModel.registerCommand.addListener(_onRegisterCommandChange);
  }

  @override
  void dispose() {
    _viewModel.registerCommand.removeListener(_onRegisterCommandChange);
    _viewModel.dispose();
    super.dispose();
  }

  void _onRegisterCommandChange() {
    if (!mounted) return;

    final value = _viewModel.registerCommand.value;

    // Ignore initial state
    if (value == null) return;

    // If error then show snackbar message
    final errorMessage = value.tryGetError();
    if (errorMessage != null) {
      showErrorSnackbar(context, errorMessage);
    }

    // If successful then go to home
    if (value.isSuccess()) {
      context.go(Routes.destinations);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LoginDecorator(
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 8),
        child: Form(
          key: controller.formKey,
          child: Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Headline
              Text('Cadastre-se', style: theme.textTheme.headlineSmall),

              // Name field
              TextFormField(
                controller: controller.nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                keyboardType: TextInputType.emailAddress,
                validator: controller.validateName,
              ),

              // Email field
              TextFormField(
                controller: controller.emailController,
                decoration: const InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                validator: controller.validateEmail,
              ),

              // Password field
              TextFormField(
                controller: controller.passwordController,
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: controller.validatePassword,
              ),

              // Confirm Password field
              TextFormField(
                controller: controller.confirmPasswordController,
                decoration: const InputDecoration(labelText: 'Confirmar Senha'),
                obscureText: true,
                validator: controller.validateConfirmPassword,
              ),

              // Register button
              ValueListenableBuilder(
                valueListenable: _viewModel.registerCommand.canExecute,
                builder: (context, canExecute, child) {
                  return Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: canExecute ? _handleRegister : null,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            child: Text('Criar conta'),
                          ),
                        ),
                      ),
                      // Sign up text
                      TextButton(
                        onPressed: canExecute
                            ? () {
                                context.go(Routes.login);
                              }
                            : null,
                        child: Text(
                          'Já tem uma conta? Faça login',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            decorationColor: theme.colorScheme.primary,
                            decoration: TextDecoration.underline,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      if (_viewModel.registerCommand.isExecuting.value)
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

class _FormController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool validate() {
    return formKey.currentState?.validate() ?? false;
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Por favor, insira seu nome";
    }

    if (value.length < 4) {
      return "Nome deve ter pelo menos 4 caracteres";
    }

    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira seu e-mail';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Por favor, insira um e-mail válido';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira sua senha';
    }

    if (value.length < 8) {
      return 'A senha deve ter pelo menos 8 caracteres';
    }

    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, confirme sua senha';
    }

    if (value != passwordController.text) {
      return 'As senhas não coincidem';
    }

    return null;
  }

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}
