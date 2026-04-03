import 'package:elder_guard_app/app/theme/app_colors.dart';
import 'package:elder_guard_app/features/menu/presentation/models/menu_action_item.dart';
import 'package:flutter/material.dart';

class MenuActionTile extends StatelessWidget {
  const MenuActionTile({
    required this.item,
    required this.onTap,
    this.isBusy = false,
    super.key,
  });

  final MenuActionItem item;
  final VoidCallback? onTap;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    final accentColor =
        item.isDestructive ? AppColors.error : AppColors.tealPrimary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: isBusy ? null : onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.84),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: accentColor.withValues(alpha: 0.14)),
          ),
          child: Row(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(item.icon, color: accentColor),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  item.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color:
                        item.isDestructive
                            ? AppColors.error
                            : AppColors.deepTeal,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              if (isBusy)
                SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: accentColor,
                  ),
                )
              else
                Icon(
                  item.isDestructive
                      ? Icons.logout_rounded
                      : Icons.chevron_right_rounded,
                  color: accentColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
