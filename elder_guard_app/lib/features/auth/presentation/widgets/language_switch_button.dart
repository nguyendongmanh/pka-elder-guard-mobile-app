import 'package:elder_guard_app/app/theme/app_colors.dart';
import 'package:elder_guard_app/core/localization/locale_controller.dart';
import 'package:elder_guard_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageSwitchButton extends ConsumerWidget {
  const LanguageSwitchButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeControllerProvider);
    final l10n = AppLocalizations.of(context)!;

    return Tooltip(
      message: l10n.switchLanguageLabel,
      child: FilledButton.icon(
        onPressed:
            () => ref.read(localeControllerProvider.notifier).toggleLocale(),
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 44),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          backgroundColor: Colors.white.withValues(alpha: 0.88),
          foregroundColor: AppColors.deepTeal,
          textStyle: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        icon: const Icon(Icons.translate_rounded, size: 18),
        label: Text(locale.languageCode.toUpperCase()),
      ),
    );
  }
}
