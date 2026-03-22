import 'package:elder_guard_app/app/theme/app_colors.dart';
import 'package:elder_guard_app/core/config/app_config.dart';
import 'package:elder_guard_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:elder_guard_app/features/auth/presentation/widgets/auth_background.dart';
import 'package:elder_guard_app/features/auth/presentation/widgets/language_switch_button.dart';
import 'package:elder_guard_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final l10n = AppLocalizations.of(context)!;
    final email = authState.session?.email ?? '';

    return Scaffold(
      body: AuthBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Align(
                      alignment: Alignment.topRight,
                      child: LanguageSwitchButton(),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.82),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.deepTeal.withValues(alpha: 0.12),
                            blurRadius: 28,
                            offset: const Offset(0, 16),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/elderguard_logoapp.png',
                            width: 140,
                          ),
                          const SizedBox(height: 18),
                          Text(
                            l10n.homeTitle,
                            style: GoogleFonts.merriweather(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: AppColors.deepTeal,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            l10n.homeSubtitle,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 18),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: AppColors.creamLight,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.sand,
                                width: 1.2,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.signedInAs(email),
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  l10n.connectedToApi(AppConfig.baseUrl),
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 22),
                          FilledButton(
                            onPressed:
                                authState.isSubmitting
                                    ? null
                                    : () =>
                                        ref
                                            .read(
                                              authControllerProvider.notifier,
                                            )
                                            .logout(),
                            child: Text(l10n.logoutAction),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
