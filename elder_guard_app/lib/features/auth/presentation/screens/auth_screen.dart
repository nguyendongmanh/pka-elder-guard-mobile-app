import 'dart:math' as math;

import 'package:elder_guard_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:elder_guard_app/features/auth/presentation/utils/auth_failure_message.dart';
import 'package:elder_guard_app/features/auth/presentation/utils/auth_mode.dart';
import 'package:elder_guard_app/features/auth/presentation/widgets/auth_background.dart';
import 'package:elder_guard_app/features/auth/presentation/widgets/auth_branding.dart';
import 'package:elder_guard_app/features/auth/presentation/widgets/auth_form.dart';
import 'package:elder_guard_app/features/auth/presentation/widgets/language_switch_button.dart';
import 'package:elder_guard_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  AuthMode _mode = AuthMode.login;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      body: AuthBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Align(
                  alignment: Alignment.topRight,
                  child: LanguageSwitchButton(),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final contentWidth = math.min(
                        constraints.maxWidth,
                        430.0,
                      );

                      return Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.topCenter,
                          child: SizedBox(
                            width: contentWidth,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                AuthBranding(mode: _mode),
                                const SizedBox(height: 24),
                                AuthForm(
                                  mode: _mode,
                                  formKey: _formKey,
                                  usernameController: _usernameController,
                                  emailController: _emailController,
                                  passwordController: _passwordController,
                                  obscurePassword: _obscurePassword,
                                  isSubmitting: authState.isSubmitting,
                                  onToggleMode: _toggleMode,
                                  onTogglePasswordVisibility:
                                      _togglePasswordVisibility,
                                  onSubmit: _submit,
                                  onForgotPassword: _showForgotPasswordFeedback,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _toggleMode() {
    setState(() {
      _mode = _mode.isLogin ? AuthMode.register : AuthMode.login;
      _passwordController.clear();
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    final controller = ref.read(authControllerProvider.notifier);

    final result =
        _mode.isLogin
            ? await controller.login(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            )
            : await controller.register(
              username: _usernameController.text.trim(),
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );

    if (!mounted || result.isSuccess && _mode.isLogin) {
      return;
    }

    final l10n = AppLocalizations.of(context)!;

    if (!result.isSuccess && result.error != null) {
      _showMessage(authFailureMessage(l10n, result.error!));
      return;
    }

    _passwordController.clear();
    _usernameController.clear();
    setState(() {
      _mode = AuthMode.login;
    });
    _showMessage(l10n.registerSuccessMessage);
  }

  void _showForgotPasswordFeedback() {
    final l10n = AppLocalizations.of(context)!;
    _showMessage(l10n.forgotPasswordUnavailable);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
