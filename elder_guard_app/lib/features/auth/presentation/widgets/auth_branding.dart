import 'dart:math' as math;

import 'package:elder_guard_app/app/theme/app_colors.dart';
import 'package:elder_guard_app/features/auth/presentation/utils/auth_mode.dart';
import 'package:elder_guard_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class AuthBranding extends StatelessWidget {
  const AuthBranding({required this.mode, super.key});

  final AuthMode mode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.sizeOf(context).width;

    return Column(
      children: [
        const SizedBox(height: 10),
        Image.asset(
          'assets/elderguard_logoapp.png',
          width: math.min(width * 0.42, 172),
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 14),
        Text(
          mode.isLogin ? l10n.loginIntro : l10n.registerIntro,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.textDark.withValues(alpha: 0.88),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
