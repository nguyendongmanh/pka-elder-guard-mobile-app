import 'package:elder_guard_app/app/theme/app_colors.dart';
import 'package:elder_guard_app/features/monitoring/presentation/controllers/monitoring_cameras_controller.dart';
import 'package:elder_guard_app/features/monitoring/presentation/models/demo_camera_item.dart';
import 'package:elder_guard_app/features/monitoring/presentation/screens/monitoring_camera_detail_screen.dart';
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
    final screenWidth = MediaQuery.sizeOf(context).width;
    final cameraTileHeight = screenWidth < 390 ? 270.0 : 250.0;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return RefreshIndicator(
      color: AppColors.tealPrimary,
      onRefresh:
          ref
              .read(monitoringCamerasControllerProvider.notifier)
              .refreshCameraOrder,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
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
                padding: EdgeInsets.only(bottom: bottomInset + 132),
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
              padding: EdgeInsets.only(bottom: bottomInset + 132),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 14,
                  mainAxisExtent: cameraTileHeight,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final camera = state.cameras[index];
                  return CameraGridTile(
                    camera: camera,
                    isHighlighted: camera.highlightedByAlert,
                    onTap: () {
                      ref
                          .read(monitoringCamerasControllerProvider.notifier)
                          .focusCamera(camera.id);
                      _openCameraDetail(context, camera: camera);
                    },
                    onSelectedAction:
                        (action) =>
                            _handleTileAction(context, ref, camera, action),
                  );
                }, childCount: state.cameras.length),
              ),
            ),
        ],
      ),
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

  void _openCameraDetail(
    BuildContext context, {
    required DemoCameraItem camera,
    String? eventType,
    DateTime? alertTime,
    bool openedFromAlert = false,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder:
            (context) => MonitoringCameraDetailScreen(
              camera: camera,
              eventType: eventType,
              alertTime: alertTime,
              openedFromAlert: openedFromAlert,
            ),
      ),
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
