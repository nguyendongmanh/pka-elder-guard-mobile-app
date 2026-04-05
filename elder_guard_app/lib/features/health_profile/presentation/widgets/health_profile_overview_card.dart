import 'package:elder_guard_app/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class HealthProfileOverviewCard extends StatelessWidget {
  const HealthProfileOverviewCard({
    required this.demoBadge,
    required this.name,
    required this.ageLabel,
    required this.bloodTypeLabel,
    required this.careLevelLabel,
    super.key,
  });

  final String demoBadge;
  final String name;
  final String ageLabel;
  final String bloodTypeLabel;
  final String careLevelLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppColors.tealPrimary.withValues(alpha: 0.14),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepTeal.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 66,
            width: 66,
            decoration: BoxDecoration(
              color: AppColors.tealPrimary.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.favorite_rounded,
              color: AppColors.tealPrimary,
              size: 34,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    demoBadge,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.deepTeal,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  ageLabel,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textDark.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  bloodTypeLabel,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textDark.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  careLevelLabel,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textDark.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
