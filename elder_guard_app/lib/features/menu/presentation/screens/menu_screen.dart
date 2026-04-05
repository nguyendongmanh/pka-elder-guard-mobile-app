import 'package:elder_guard_app/app/theme/app_colors.dart';
import 'package:elder_guard_app/features/health_profile/presentation/screens/health_profile_screen.dart';
import 'package:elder_guard_app/features/menu/presentation/models/menu_action_item.dart';
import 'package:elder_guard_app/features/menu/presentation/widgets/menu_action_tile.dart';
import 'package:elder_guard_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({
    required this.isLoggingOut,
    required this.onLogout,
    super.key,
  });

  final bool isLoggingOut;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final items = <MenuActionItem>[
      MenuActionItem(
        kind: MenuActionKind.personalInfo,
        title: l10n.menuPersonalInfoTitle,
        icon: Icons.person_outline_rounded,
      ),
      MenuActionItem(
        kind: MenuActionKind.healthProfile,
        title: l10n.menuHealthProfileTitle,
        icon: Icons.favorite_outline_rounded,
      ),
      MenuActionItem(
        kind: MenuActionKind.settingsPrivacy,
        title: l10n.menuSettingsPrivacyTitle,
        icon: Icons.shield_outlined,
      ),
      MenuActionItem(
        kind: MenuActionKind.about,
        title: l10n.menuAboutTitle,
        icon: Icons.info_outline_rounded,
      ),
      MenuActionItem(
        kind: MenuActionKind.logout,
        title: l10n.logoutAction,
        icon: Icons.logout_rounded,
        isDestructive: true,
      ),
    ];

    return ListView(
      padding: const EdgeInsets.only(bottom: 28),
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 22),
          child: Text(
            l10n.menuTitle,
            style: GoogleFonts.merriweather(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: AppColors.deepTeal,
            ),
          ),
        ),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: MenuActionTile(
              item: item,
              isBusy: item.kind == MenuActionKind.logout && isLoggingOut,
              onTap: () => _handleItemTap(context, item),
            ),
          ),
        ),
      ],
    );
  }

  void _handleItemTap(BuildContext context, MenuActionItem item) {
    final l10n = AppLocalizations.of(context)!;
    if (item.kind == MenuActionKind.logout) {
      onLogout();
      return;
    }

    if (item.kind == MenuActionKind.healthProfile) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => const HealthProfileScreen(),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(l10n.menuComingSoonMessage(item.title))),
      );
  }
}
