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
  });

  factory MonitoringCamerasState.initial() {
    return MonitoringCamerasState(
      cameras: List<DemoCameraItem>.generate(
        4,
        (index) => DemoCameraItem(id: index + 1, name: 'Camera ${index + 1}'),
      ),
      nextCameraNumber: 5,
    );
  }

  final List<DemoCameraItem> cameras;
  final int nextCameraNumber;
}

class MonitoringCamerasController extends Notifier<MonitoringCamerasState> {
  @override
  MonitoringCamerasState build() => MonitoringCamerasState.initial();

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
    );
  }

  void deleteCamera(int cameraId) {
    state = MonitoringCamerasState(
      cameras: state.cameras
          .where((camera) => camera.id != cameraId)
          .toList(growable: false),
      nextCameraNumber: state.nextCameraNumber,
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
