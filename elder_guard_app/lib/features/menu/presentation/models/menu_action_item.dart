import 'package:flutter/material.dart';

enum MenuActionKind {
  personalInfo,
  healthProfile,
  settingsPrivacy,
  about,
  logout,
}

class MenuActionItem {
  const MenuActionItem({
    required this.kind,
    required this.title,
    required this.icon,
    this.isDestructive = false,
  });

  final MenuActionKind kind;
  final String title;
  final IconData icon;
  final bool isDestructive;
}
