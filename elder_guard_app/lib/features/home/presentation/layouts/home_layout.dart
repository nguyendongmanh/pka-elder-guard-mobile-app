import 'dart:async';

import 'package:elder_guard_app/app/theme/app_colors.dart';
import 'package:elder_guard_app/core/notifications/device_notification_service.dart';
import 'package:elder_guard_app/core/notifications/one_signal_service.dart';
import 'package:elder_guard_app/features/auth/data/models/auth_session.dart';
import 'package:elder_guard_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:elder_guard_app/features/auth/presentation/widgets/auth_background.dart';
import 'package:elder_guard_app/features/auth/presentation/widgets/language_switch_button.dart';
import 'package:elder_guard_app/features/geofence/presentation/screens/geofence_setup_screen.dart';
import 'package:elder_guard_app/features/health_profile/presentation/screens/health_profile_screen.dart';
import 'package:elder_guard_app/features/home/presentation/models/home_service_item.dart';
import 'package:elder_guard_app/features/home/presentation/widgets/home_bottom_action_bar.dart';
import 'package:elder_guard_app/features/home/presentation/widgets/home_service_dashboard.dart';
import 'package:elder_guard_app/features/menu/presentation/screens/menu_screen.dart';
import 'package:elder_guard_app/features/monitoring/presentation/controllers/monitoring_cameras_controller.dart';
import 'package:elder_guard_app/features/monitoring/presentation/models/demo_camera_item.dart';
import 'package:elder_guard_app/features/monitoring/presentation/screens/monitoring_camera_detail_screen.dart';
import 'package:elder_guard_app/features/monitoring/presentation/screens/monitoring_screen.dart';
import 'package:elder_guard_app/core/notifications/models/push_notification_record.dart';
import 'package:elder_guard_app/features/notifications/presentation/controllers/notification_center_controller.dart';
import 'package:elder_guard_app/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:elder_guard_app/features/notifications/presentation/widgets/notification_popup_card.dart';
import 'package:elder_guard_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeLayout extends ConsumerStatefulWidget {
  const HomeLayout({super.key});

  @override
  ConsumerState<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends ConsumerState<HomeLayout> {
  static const Duration _labelVisibilityDuration = Duration(seconds: 2);
  static const int _notificationsTabIndex = 2;
  static const Duration _deferredBootstrapDelay = Duration(milliseconds: 350);
  static const Duration _popupDuration = Duration(seconds: 4);

  int _currentIndex = 0;
  int? _visibleLabelIndex;
  Timer? _labelTimer;
  Timer? _popupTimer;
  OverlayEntry? _popupOverlayEntry;
  StreamSubscription<String>? _notificationTapSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_bootstrapAfterFirstFrame());
    });
  }

  @override
  void dispose() {
    _labelTimer?.cancel();
    _popupTimer?.cancel();
    _removePopupOverlay();
    _notificationTapSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final unreadNotificationCount = ref.watch(
      notificationCenterControllerProvider.select((state) => state.unreadCount),
    );
    ref.listen<NotificationPopupRequest?>(
      notificationCenterControllerProvider.select(
        (state) => state.pendingPopup,
      ),
      (previous, next) {
        if (next == null || previous?.sequence == next.sequence || !mounted) {
          return;
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) {
            return;
          }

          _showPopupOverlay(next.notification);

          ref
              .read(notificationCenterControllerProvider.notifier)
              .consumePopup(next.sequence);
        });
      },
    );
    ref.listen<NotificationOpenRequest?>(
      notificationCenterControllerProvider.select(
        (state) => state.pendingOpenRequest,
      ),
      (previous, next) {
        if (next == null || previous?.sequence == next.sequence || !mounted) {
          return;
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) {
            return;
          }

          _openNotificationTarget(notificationId: next.notificationId);
          ref
              .read(notificationCenterControllerProvider.notifier)
              .consumeOpenRequest(next.sequence);
        });
      },
    );

    final l10n = AppLocalizations.of(context)!;
    final session = ref.watch(
      authControllerProvider.select((state) => state.session),
    );
    final isSubmitting = ref.watch(
      authControllerProvider.select((state) => state.isSubmitting),
    );
    final homeServiceItems = <HomeServiceItem>[
      HomeServiceItem(
        kind: HomeServiceKind.safeZone,
        title: l10n.homeServiceSafeZoneTitle,
        subtitle: l10n.homeServiceSafeZoneSubtitle,
        icon: Icons.my_location_rounded,
        accentColor: AppColors.tealPrimary,
      ),
      HomeServiceItem(
        kind: HomeServiceKind.monitoring,
        title: l10n.monitoringTitle,
        subtitle: l10n.homeServiceMonitoringSubtitle,
        icon: Icons.videocam_rounded,
        accentColor: AppColors.tealSecondary,
      ),
      HomeServiceItem(
        kind: HomeServiceKind.notifications,
        title: l10n.notificationCenterTitle,
        subtitle: l10n.homeServiceNotificationsSubtitle,
        icon: Icons.notifications_active_rounded,
        accentColor: AppColors.notificationBlue,
      ),
      HomeServiceItem(
        kind: HomeServiceKind.healthProfile,
        title: l10n.menuHealthProfileTitle,
        subtitle: l10n.homeServiceHealthProfileSubtitle,
        icon: Icons.favorite_rounded,
        accentColor: const Color(0xFFD86E4A),
      ),
      HomeServiceItem(
        kind: HomeServiceKind.medication,
        title: l10n.homeServiceMedicationTitle,
        subtitle: l10n.homeServiceMedicationSubtitle,
        icon: Icons.medication_liquid_rounded,
        accentColor: const Color(0xFFE0952E),
      ),
      HomeServiceItem(
        kind: HomeServiceKind.familyContacts,
        title: l10n.homeServiceFamilyTitle,
        subtitle: l10n.homeServiceFamilySubtitle,
        icon: Icons.groups_rounded,
        accentColor: const Color(0xFF8F5FBF),
      ),
    ];
    final items = <HomeBottomBarItemData>[
      HomeBottomBarItemData(
        label: l10n.navHome,
        icon: Icons.home_rounded,
        selectedIcon: Icons.home_rounded,
      ),
      HomeBottomBarItemData(
        label: l10n.navMonitoring,
        icon: Icons.videocam_outlined,
        selectedIcon: Icons.videocam_rounded,
      ),
      HomeBottomBarItemData(
        label: l10n.navAlerts,
        icon: Icons.notifications_none_rounded,
        selectedIcon: Icons.notifications_rounded,
        badgeCount: unreadNotificationCount,
      ),
      HomeBottomBarItemData(
        label: l10n.navMenu,
        icon: Icons.menu_rounded,
        selectedIcon: Icons.menu_rounded,
      ),
    ];

    return Scaffold(
      extendBody: true,
      body: AuthBackground(
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 430,
                      minHeight: constraints.maxHeight,
                    ),
                    child: SizedBox(
                      height: constraints.maxHeight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  'Elder Guard',
                                  style: GoogleFonts.merriweather(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.creamLight,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const LanguageSwitchButton(),
                            ],
                          ),
                          const SizedBox(height: 22),
                          Expanded(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 260),
                              switchInCurve: Curves.easeOut,
                              switchOutCurve: Curves.easeIn,
                              transitionBuilder: (child, animation) {
                                final offsetAnimation = Tween<Offset>(
                                  begin: const Offset(0.08, 0),
                                  end: Offset.zero,
                                ).animate(animation);

                                return FadeTransition(
                                  opacity: animation,
                                  child: SlideTransition(
                                    position: offsetAnimation,
                                    child: child,
                                  ),
                                );
                              },
                              child: KeyedSubtree(
                                key: ValueKey(_currentIndex),
                                child: _buildTabContent(
                                  session: session,
                                  isSubmitting: isSubmitting,
                                  homeServiceItems: homeServiceItems,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: HomeBottomActionBar(
        items: items,
        currentIndex: _currentIndex,
        visibleLabelIndex: _visibleLabelIndex,
        onTap: _handleTabTap,
      ),
    );
  }

  Widget _buildTabContent({
    required AuthSession? session,
    required bool isSubmitting,
    required List<HomeServiceItem> homeServiceItems,
  }) {
    if (_currentIndex == _notificationsTabIndex) {
      return const NotificationsScreen();
    }

    if (_currentIndex == 0) {
      return HomeServiceDashboard(
        session: session,
        items: homeServiceItems,
        onServiceSelected: (kind) => _handleHomeServiceSelection(kind, session),
      );
    }

    if (_currentIndex == 1) {
      return const MonitoringScreen();
    }

    if (_currentIndex == 3) {
      return MenuScreen(
        isLoggingOut: isSubmitting,
        onLogout: () => ref.read(authControllerProvider.notifier).logout(),
      );
    }

    return const SizedBox.expand();
  }

  void _handleHomeServiceSelection(HomeServiceKind kind, AuthSession? session) {
    final l10n = AppLocalizations.of(context)!;

    switch (kind) {
      case HomeServiceKind.safeZone:
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder:
                (context) => GeofenceSetupScreen(
                  initialDeviceId: _buildInitialDeviceId(session),
                ),
          ),
        );
        return;
      case HomeServiceKind.monitoring:
        _handleTabTap(1);
        return;
      case HomeServiceKind.notifications:
        _openNotificationsTab();
        return;
      case HomeServiceKind.healthProfile:
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => const HealthProfileScreen(),
          ),
        );
        return;
      case HomeServiceKind.medication:
        _showServiceSnackbar(
          l10n.menuComingSoonMessage(l10n.homeServiceMedicationTitle),
        );
        return;
      case HomeServiceKind.familyContacts:
        _showServiceSnackbar(
          l10n.menuComingSoonMessage(l10n.homeServiceFamilyTitle),
        );
        return;
    }
  }

  String _buildInitialDeviceId(AuthSession? session) {
    final userId = session?.userId?.trim();
    if (userId != null && userId.isNotEmpty) {
      return 'mobile-$userId';
    }

    final email = session?.email.trim();
    if (email != null && email.isNotEmpty) {
      return email;
    }

    return 'demo-device-01';
  }

  Future<void> _bootstrapAfterFirstFrame() async {
    await Future<void>.delayed(_deferredBootstrapDelay);
    if (!mounted) {
      return;
    }

    await _initializeNotifications();
    if (!mounted) {
      return;
    }
  }

  Future<void> _initializeNotifications() async {
    final deviceNotificationService = ref.read(
      deviceNotificationServiceProvider,
    );
    final oneSignalService = ref.read(oneSignalServiceProvider);
    await deviceNotificationService.initialize();
    await oneSignalService.initialize();

    _notificationTapSubscription = deviceNotificationService.tapPayloadStream
        .listen((payload) {
          debugPrint(
            'Push pipeline: device notification tapped payload=$payload',
          );
          _openNotificationTarget(notificationId: payload);
        });

    final pendingPayload = deviceNotificationService.takePendingPayload();
    if (pendingPayload != null && pendingPayload.isNotEmpty) {
      debugPrint(
        'Push pipeline: app launched from device notification payload=$pendingPayload',
      );
      _openNotificationTarget(notificationId: pendingPayload);
    }

    final notificationCenterState = ref.read(
      notificationCenterControllerProvider,
    );
    final pendingPopup = notificationCenterState.pendingPopup;
    if (pendingPopup != null) {
      _showPopupOverlay(pendingPopup.notification);
      ref
          .read(notificationCenterControllerProvider.notifier)
          .consumePopup(pendingPopup.sequence);
    }

    final pendingOpenRequest = notificationCenterState.pendingOpenRequest;
    if (pendingOpenRequest != null) {
      _openNotificationTarget(
        notificationId: pendingOpenRequest.notificationId,
      );
      ref
          .read(notificationCenterControllerProvider.notifier)
          .consumeOpenRequest(pendingOpenRequest.sequence);
    }
  }

  void _handleTabTap(int index) {
    _labelTimer?.cancel();

    setState(() {
      _currentIndex = index;
      _visibleLabelIndex = index;
    });

    _labelTimer = Timer(_labelVisibilityDuration, () {
      if (!mounted) {
        return;
      }

      setState(() {
        _visibleLabelIndex = null;
      });
    });
  }

  void _openNotificationsTab({String? readNotificationId}) {
    if (!mounted) {
      return;
    }

    if (readNotificationId != null && readNotificationId.isNotEmpty) {
      ref
          .read(notificationCenterControllerProvider.notifier)
          .markAsRead(readNotificationId);
    }

    _removePopupOverlay();
    _handleTabTap(_notificationsTabIndex);
  }

  void _openNotificationTarget({String? notificationId}) {
    if (!mounted) {
      return;
    }

    final normalizedNotificationId = notificationId?.trim();
    if (normalizedNotificationId == null || normalizedNotificationId.isEmpty) {
      _openNotificationsTab();
      return;
    }

    final notificationCenterController = ref.read(
      notificationCenterControllerProvider.notifier,
    );
    final notification = _findNotificationById(normalizedNotificationId);
    notificationCenterController.markAsRead(normalizedNotificationId);

    final cameraId = notification?.cameraId;
    if (cameraId != null) {
      ref
          .read(monitoringCamerasControllerProvider.notifier)
          .focusCamera(cameraId);
      final camera = _findCameraById(cameraId);
      _removePopupOverlay();
      _handleTabTap(1);
      if (camera != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) {
            return;
          }

          _openCameraDetail(
            camera: camera,
            eventType: notification?.eventType,
            alertTime: notification?.receivedAt,
            openedFromAlert: true,
          );
        });
      }
      return;
    }

    _openNotificationsTab(readNotificationId: normalizedNotificationId);
  }

  PushNotificationRecord? _findNotificationById(String notificationId) {
    final notifications =
        ref.read(notificationCenterControllerProvider).notifications;
    for (final notification in notifications) {
      if (notification.id == notificationId) {
        return notification;
      }
    }

    return null;
  }

  DemoCameraItem? _findCameraById(int cameraId) {
    final cameras = ref.read(monitoringCamerasControllerProvider).cameras;
    for (final camera in cameras) {
      if (camera.id == cameraId) {
        return camera;
      }
    }

    return null;
  }

  void _openCameraDetail({
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

  void _showPopupOverlay(PushNotificationRecord notification) {
    _popupTimer?.cancel();
    _removePopupOverlay();
    debugPrint('Push pipeline: showing in-app popup id=${notification.id}');

    final overlay = Overlay.of(context, rootOverlay: true);
    final topPadding = MediaQuery.paddingOf(context).top;
    _popupOverlayEntry = OverlayEntry(
      builder:
          (context) => SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.fromLTRB(14, topPadding + 12, 14, 0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: Material(
                    color: Colors.transparent,
                    child: NotificationPopupCard(
                      notification: notification,
                      onOpen:
                          () => _openNotificationTarget(
                            notificationId: notification.id,
                          ),
                    ),
                  ),
                ),
              ),
            ),
          ),
    );
    overlay.insert(_popupOverlayEntry!);

    _popupTimer = Timer(_popupDuration, _removePopupOverlay);
  }

  void _removePopupOverlay() {
    _popupTimer?.cancel();
    _popupTimer = null;
    _popupOverlayEntry?.remove();
    _popupOverlayEntry = null;
  }

  void _showServiceSnackbar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
