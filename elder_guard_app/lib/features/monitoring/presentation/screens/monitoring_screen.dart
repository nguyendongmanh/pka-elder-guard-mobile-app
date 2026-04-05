import 'package:elder_guard_app/app/theme/app_colors.dart';
import 'package:elder_guard_app/features/monitoring/presentation/controllers/monitoring_cameras_controller.dart';
import 'package:elder_guard_app/features/monitoring/presentation/models/demo_camera_item.dart';
import 'package:elder_guard_app/features/monitoring/presentation/widgets/camera_grid_tile.dart';
import 'package:elder_guard_app/features/monitoring/presentation/widgets/camera_name_dialog.dart';
import 'package:elder_guard_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class MonitoringScreen extends ConsumerWidget {
  const MonitoringScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(monitoringCamerasControllerProvider);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.monitoringTitle,
                        style: GoogleFonts.merriweather(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: AppColors.deepTeal,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.monitoringSubtitle,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                FilledButton(
                  onPressed:
                      () => _showAddCameraDialog(
                        context,
                        ref,
                        state.nextCameraNumber,
                      ),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.tealPrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Icon(Icons.add_rounded, size: 24),
                ),
              ],
            ),
          ),
        ),
        if (state.cameras.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 28),
              child: _EmptyMonitoringState(
                onAddPressed:
                    () => _showAddCameraDialog(
                      context,
                      ref,
                      state.nextCameraNumber,
                    ),
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 28),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.82,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final camera = state.cameras[index];
                return CameraGridTile(
                  camera: camera,
                  onTap: () => _showDemoTapMessage(context, camera),
                  onSelectedAction:
                      (action) =>
                          _handleTileAction(context, ref, camera, action),
                );
              }, childCount: state.cameras.length),
            ),
          ),
      ],
    );
  }

  Future<void> _showAddCameraDialog(
    BuildContext context,
    WidgetRef ref,
    int nextCameraNumber,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final suggestedName = 'Camera $nextCameraNumber';
    final cameraName = await showDialog<String>(
      context: context,
      builder:
          (context) => CameraNameDialog(
            title: l10n.monitoringAddCameraTitle,
            initialValue: suggestedName,
            label: l10n.monitoringCameraNameLabel,
            hint: l10n.monitoringCameraNameHint,
            cancelLabel: l10n.monitoringCancelAction,
            confirmLabel: l10n.monitoringSaveAction,
            validationMessage: l10n.requiredFieldError,
          ),
    );

    if (!context.mounted || cameraName == null) {
      return;
    }

    ref
        .read(monitoringCamerasControllerProvider.notifier)
        .addCamera(name: cameraName);
  }

  Future<void> _showRenameDialog(
    BuildContext context,
    WidgetRef ref,
    DemoCameraItem camera,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final updatedName = await showDialog<String>(
      context: context,
      builder:
          (context) => CameraNameDialog(
            title: l10n.monitoringEditCameraTitle,
            initialValue: camera.name,
            label: l10n.monitoringCameraNameLabel,
            hint: l10n.monitoringCameraNameHint,
            cancelLabel: l10n.monitoringCancelAction,
            confirmLabel: l10n.monitoringSaveAction,
            validationMessage: l10n.requiredFieldError,
          ),
    );

    if (!context.mounted || updatedName == null) {
      return;
    }

    ref
        .read(monitoringCamerasControllerProvider.notifier)
        .renameCamera(cameraId: camera.id, name: updatedName);
  }

  void _handleTileAction(
    BuildContext context,
    WidgetRef ref,
    DemoCameraItem camera,
    CameraTileMenuAction action,
  ) {
    switch (action) {
      case CameraTileMenuAction.rename:
        _showRenameDialog(context, ref, camera);
        return;
      case CameraTileMenuAction.delete:
        ref
            .read(monitoringCamerasControllerProvider.notifier)
            .deleteCamera(camera.id);
        return;
    }
  }

  void _showDemoTapMessage(BuildContext context, DemoCameraItem camera) {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(l10n.monitoringDemoTapMessage(camera.name))),
      );
  }
}

class _EmptyMonitoringState extends StatelessWidget {
  const _EmptyMonitoringState({required this.onAddPressed});

  final VoidCallback onAddPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.84),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppColors.tealPrimary.withValues(alpha: 0.14),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.monitoringEmptyTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.deepTeal,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.monitoringEmptyDescription,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textDark.withValues(alpha: 0.78),
              fontWeight: FontWeight.w700,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onAddPressed,
            icon: const Icon(Icons.add_rounded),
            label: Text(l10n.monitoringAddCameraAction),
          ),
        ],
      ),
    );
  }
}
