import 'dart:async';

import 'package:elder_guard_app/app/theme/app_colors.dart';
import 'package:elder_guard_app/core/notifications/device_notification_service.dart';
import 'package:elder_guard_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:elder_guard_app/features/auth/presentation/widgets/auth_background.dart';
import 'package:elder_guard_app/features/auth/presentation/widgets/language_switch_button.dart';
import 'package:elder_guard_app/features/home/presentation/widgets/home_bottom_action_bar.dart';
import 'package:elder_guard_app/features/notifications/presentation/controllers/event_notifications_controller.dart';
import 'package:elder_guard_app/features/notifications/presentation/screens/notifications_screen.dart';
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

  int _currentIndex = 0;
  int? _visibleLabelIndex;
  Timer? _labelTimer;
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
    _notificationTapSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isSubmitting = ref.watch(
      authControllerProvider.select((state) => state.isSubmitting),
    );
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
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
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
                            isSubmitting: isSubmitting,
                            l10n: l10n,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
    required bool isSubmitting,
    required AppLocalizations l10n,
  }) {
    if (_currentIndex == _notificationsTabIndex) {
      return const NotificationsScreen();
    }

    if (_currentIndex == 0) {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 240),
          child: FilledButton.icon(
            onPressed:
                isSubmitting
                    ? null
                    : () => ref.read(authControllerProvider.notifier).logout(),
            icon: const Icon(Icons.logout_rounded),
            label: Text(l10n.logoutAction),
          ),
        ),
      );
    }

    return const SizedBox.expand();
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

    unawaited(ref.read(eventNotificationsControllerProvider.future));
  }

  Future<void> _initializeNotifications() async {
    final deviceNotificationService = ref.read(
      deviceNotificationServiceProvider,
    );
    await deviceNotificationService.requestPermissions();

    _notificationTapSubscription = deviceNotificationService.tapPayloadStream
        .listen((_) => _openNotificationsTab());

    final pendingPayload = deviceNotificationService.takePendingPayload();
    if (pendingPayload != null && pendingPayload.isNotEmpty) {
      _openNotificationsTab();
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

  void _openNotificationsTab() {
    if (!mounted) {
      return;
    }

    _handleTabTap(_notificationsTabIndex);
  }
}
