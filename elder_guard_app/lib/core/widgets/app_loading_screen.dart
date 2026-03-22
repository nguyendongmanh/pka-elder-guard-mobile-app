import 'package:elder_guard_app/app/theme/app_colors.dart';
import 'package:elder_guard_app/features/auth/presentation/widgets/auth_background.dart';
import 'package:elder_guard_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppLoadingScreen extends StatelessWidget {
  const AppLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: AuthBackground(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/elderguard_logoapp.png', width: 180),
                const SizedBox(height: 18),
                Text(
                  l10n.loadingMessage,
                  style: GoogleFonts.merriweather(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.deepTeal,
                  ),
                ),
                const SizedBox(height: 20),
                const CircularProgressIndicator(color: AppColors.tealPrimary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
