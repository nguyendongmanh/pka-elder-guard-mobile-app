import 'package:flutter/material.dart';

enum HomeServiceKind {
  safeZone,
  monitoring,
  notifications,
  healthProfile,
  medication,
  familyContacts,
}

class HomeServiceItem {
  const HomeServiceItem({
    required this.kind,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
  });

  final HomeServiceKind kind;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
}
