import 'package:elder_guard_app/app/theme/app_colors.dart';
import 'package:elder_guard_app/core/config/app_config.dart';
import 'package:elder_guard_app/features/auth/data/models/auth_session.dart';
import 'package:elder_guard_app/features/home/presentation/models/home_service_item.dart';
import 'package:elder_guard_app/features/home/presentation/widgets/home_service_tile.dart';
import 'package:elder_guard_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeServiceDashboard extends StatelessWidget {
  const HomeServiceDashboard({
    required this.session,
    required this.items,
    required this.onServiceSelected,
    super.key,
  });

  final AuthSession? session;
  final List<HomeServiceItem> items;
  final ValueChanged<HomeServiceKind> onServiceSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final crossAxisCount = screenWidth < 340 ? 1 : 2;
    final tileHeight = screenWidth < 390 ? 256.0 : 240.0;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _DashboardHeroCard(
            session: session,
            title: l10n.homeServicesTitle,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 22, bottom: 16),
            child: Text(
              l10n.homeServicesSectionTitle,
              style: GoogleFonts.merriweather(
                fontSize: 27,
                fontWeight: FontWeight.w800,
                color: AppColors.deepTeal,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(bottom: 144),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              mainAxisExtent: tileHeight,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final item = items[index];
              return HomeServiceTile(
                item: item,
                onTap: () => onServiceSelected(item.kind),
              );
            }, childCount: items.length),
          ),
        ),
      ],
    );
  }
}

class _DashboardHeroCard extends StatelessWidget {
  const _DashboardHeroCard({required this.session, required this.title});

  final AuthSession? session;
  final String title;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final signedInLabel =
        session == null ? null : l10n.signedInAs(session!.email);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.deepTeal, AppColors.tealSecondary],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepTeal.withValues(alpha: 0.24),
            blurRadius: 28,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.dashboard_customize_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Elder Guard',
                    style: textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: GoogleFonts.merriweather(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 18),
            if (signedInLabel != null) ...[
              _HeroMetaChip(
                icon: Icons.person_outline_rounded,
                label: signedInLabel,
              ),
              const SizedBox(height: 10),
            ],
            _HeroMetaChip(
              icon: Icons.cloud_done_outlined,
              label: l10n.connectedToApi(AppConfig.baseUrl),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroMetaChip extends StatelessWidget {
  const _HeroMetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
