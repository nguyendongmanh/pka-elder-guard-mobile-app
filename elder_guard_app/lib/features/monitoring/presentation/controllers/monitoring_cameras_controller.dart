import 'package:elder_guard_app/features/monitoring/presentation/models/demo_camera_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final monitoringCamerasControllerProvider =
    NotifierProvider<MonitoringCamerasController, MonitoringCamerasState>(
      MonitoringCamerasController.new,
    );

class MonitoringCamerasState {
  const MonitoringCamerasState({
    required this.cameras,
    required this.nextCameraNumber,
    this.selectedCameraId,
  });

  factory MonitoringCamerasState.initial() {
    return MonitoringCamerasState(
      cameras: _defaultDemoCameras(),
      nextCameraNumber: 5,
    );
  }

  final List<DemoCameraItem> cameras;
  final int nextCameraNumber;
  final int? selectedCameraId;

  DemoCameraItem? get selectedCamera {
    final selectedCameraId = this.selectedCameraId;
    if (selectedCameraId == null) {
      return null;
    }

    for (final camera in cameras) {
      if (camera.id == selectedCameraId) {
        return camera;
      }
    }

    return null;
  }

  static List<DemoCameraItem> _defaultDemoCameras() {
    return List<DemoCameraItem>.generate(
      4,
      (index) => DemoCameraItem(id: index + 1, name: 'Camera ${index + 1}'),
    );
  }
}

class MonitoringCamerasController extends Notifier<MonitoringCamerasState> {
  @override
  MonitoringCamerasState build() => MonitoringCamerasState.initial();

  Future<void> refreshCameraOrder() async {
    final refreshedCameras = state.cameras
        .map((camera) => camera.copyWith(highlightedByAlert: false))
        .toList(growable: false)
      ..sort((left, right) => left.id.compareTo(right.id));

    state = MonitoringCamerasState(
      cameras:
          refreshedCameras.isEmpty
              ? MonitoringCamerasState._defaultDemoCameras()
              : refreshedCameras,
      nextCameraNumber: state.nextCameraNumber,
      selectedCameraId: null,
    );

    await Future<void>.delayed(const Duration(milliseconds: 250));
  }

  void addCamera({required String name}) {
    final cameraNumber = state.nextCameraNumber;
    state = MonitoringCamerasState(
      cameras: <DemoCameraItem>[
        ...state.cameras,
        DemoCameraItem(
          id: cameraNumber,
          name: _normalizedCameraName(name, fallbackNumber: cameraNumber),
        ),
      ],
      nextCameraNumber: cameraNumber + 1,
      selectedCameraId: state.selectedCameraId,
    );
  }

  void renameCamera({required int cameraId, required String name}) {
    state = MonitoringCamerasState(
      cameras: state.cameras
          .map(
            (camera) =>
                camera.id == cameraId
                    ? camera.copyWith(
                      name: _normalizedCameraName(
                        name,
                        fallbackNumber: camera.id,
                      ),
                    )
                    : camera,
          )
          .toList(growable: false),
      nextCameraNumber: state.nextCameraNumber,
      selectedCameraId: state.selectedCameraId,
    );
  }

  void deleteCamera(int cameraId) {
    final remainingCameras = state.cameras
        .where((camera) => camera.id != cameraId)
        .map((camera) => camera.copyWith(highlightedByAlert: false))
        .toList(growable: false);
    if (remainingCameras.isEmpty) {
      state = MonitoringCamerasState.initial();
      return;
    }

    state = MonitoringCamerasState(
      cameras: remainingCameras,
      nextCameraNumber: state.nextCameraNumber,
      selectedCameraId:
          state.selectedCameraId == cameraId ? null : state.selectedCameraId,
    );
  }

  void focusCamera(int cameraId) {
    final nextCameraNumber =
        state.nextCameraNumber > cameraId
            ? state.nextCameraNumber
            : cameraId + 1;
    final reorderedCameras = state.cameras
        .where((camera) => camera.id != cameraId)
        .map((camera) => camera.copyWith(highlightedByAlert: false))
        .toList(growable: true);
    DemoCameraItem? existingCamera;
    for (final camera in state.cameras) {
      if (camera.id == cameraId) {
        existingCamera = camera;
        break;
      }
    }

    reorderedCameras.insert(
      0,
      (existingCamera ?? DemoCameraItem(id: cameraId, name: 'Camera $cameraId'))
          .copyWith(highlightedByAlert: true),
    );

    state = MonitoringCamerasState(
      cameras: reorderedCameras,
      nextCameraNumber: nextCameraNumber,
      selectedCameraId: cameraId,
    );
  }

  void clearFocusedCamera() {
    state = MonitoringCamerasState(
      cameras: state.cameras
          .map((camera) => camera.copyWith(highlightedByAlert: false))
          .toList(growable: false),
      nextCameraNumber: state.nextCameraNumber,
      selectedCameraId: null,
    );
  }

  String _normalizedCameraName(String value, {required int fallbackNumber}) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return 'Camera $fallbackNumber';
    }
    return trimmed;
  }
}
