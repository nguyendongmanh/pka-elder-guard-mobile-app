import 'package:elder_guard_app/app/theme/app_colors.dart';
import 'package:elder_guard_app/features/monitoring/presentation/models/demo_camera_item.dart';
import 'package:elder_guard_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

enum CameraTileMenuAction { rename, delete }

class CameraGridTile extends StatelessWidget {
  const CameraGridTile({
    required this.camera,
    required this.onTap,
    required this.onSelectedAction,
    super.key,
  });

  final DemoCameraItem camera;
  final VoidCallback onTap;
  final ValueChanged<CameraTileMenuAction> onSelectedAction;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.88),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.tealPrimary.withValues(alpha: 0.14),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.deepTeal.withValues(alpha: 0.08),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                        l10n.monitoringDemoBadge,
                        style: Theme.of(
                          context,
                        ).textTheme.labelMedium?.copyWith(
                          color: AppColors.error,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const Spacer(),
                    PopupMenuButton<CameraTileMenuAction>(
                      icon: const Icon(
                        Icons.more_horiz_rounded,
                        color: AppColors.tealPrimary,
                      ),
                      onSelected: onSelectedAction,
                      itemBuilder:
                          (context) => [
                            PopupMenuItem<CameraTileMenuAction>(
                              value: CameraTileMenuAction.rename,
                              child: Text(l10n.monitoringRenameAction),
                            ),
                            PopupMenuItem<CameraTileMenuAction>(
                              value: CameraTileMenuAction.delete,
                              child: Text(l10n.monitoringDeleteAction),
                            ),
                          ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.deepTeal, AppColors.tealSecondary],
                      ),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.videocam_rounded,
                          color: Colors.white,
                          size: 44,
                        ),
                        SizedBox(height: 8),
                        Icon(
                          Icons.play_circle_fill_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  camera.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.deepTeal,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.monitoringTapToView,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textDark.withValues(alpha: 0.72),
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
