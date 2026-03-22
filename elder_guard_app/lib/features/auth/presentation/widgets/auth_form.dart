import 'package:elder_guard_app/app/theme/app_colors.dart';
import 'package:elder_guard_app/features/auth/presentation/utils/auth_mode.dart';
import 'package:elder_guard_app/features/auth/presentation/utils/auth_validators.dart';
import 'package:elder_guard_app/features/auth/presentation/widgets/auth_input_field.dart';
import 'package:elder_guard_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatelessWidget {
  const AuthForm({
    required this.mode,
    required this.formKey,
    required this.usernameController,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.isSubmitting,
    required this.onToggleMode,
    required this.onTogglePasswordVisibility,
    required this.onSubmit,
    required this.onForgotPassword,
    super.key,
  });

  final AuthMode mode;
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final bool isSubmitting;
  final VoidCallback onToggleMode;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onSubmit;
  final VoidCallback onForgotPassword;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: Form(
        key: formKey,
        child: AutofillGroup(
          key: ValueKey(mode),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!mode.isLogin) ...[
                AuthInputField(
                  controller: usernameController,
                  hintText: l10n.usernameHint,
                  prefixIcon: Icons.account_circle_outlined,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.username],
                  validator: (value) => AuthValidators.username(value, l10n),
                ),
                const SizedBox(height: 18),
              ],
              AuthInputField(
                controller: emailController,
                hintText: l10n.emailHint,
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [
                  AutofillHints.username,
                  AutofillHints.email,
                ],
                validator: (value) => AuthValidators.email(value, l10n),
              ),
              const SizedBox(height: 18),
              AuthInputField(
                controller: passwordController,
                hintText: l10n.passwordHint,
                prefixIcon: Icons.lock_outline_rounded,
                obscureText: obscurePassword,
                textInputAction: TextInputAction.done,
                autofillHints: [
                  mode.isLogin
                      ? AutofillHints.password
                      : AutofillHints.newPassword,
                ],
                validator: (value) => AuthValidators.password(value, l10n),
                onFieldSubmitted: (_) => onSubmit(),
                suffixIcon: IconButton(
                  onPressed: onTogglePasswordVisibility,
                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: isSubmitting ? null : onSubmit,
                child:
                    isSubmitting
                        ? const SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.white,
                          ),
                        )
                        : Text(
                          mode.isLogin ? l10n.loginAction : l10n.registerAction,
                        ),
              ),
              if (mode.isLogin) ...[
                const SizedBox(height: 12),
                Center(
                  child: TextButton(
                    onPressed: isSubmitting ? null : onForgotPassword,
                    child: Text(l10n.forgotPassword),
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Center(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.center,
                  children: [
                    Text(
                      mode.isLogin
                          ? l10n.noAccountPrompt
                          : l10n.hasAccountPrompt,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextButton(
                      onPressed: isSubmitting ? null : onToggleMode,
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.tealPrimary,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                      ),
                      child: Text(
                        mode.isLogin ? l10n.signUpNow : l10n.signInNow,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
