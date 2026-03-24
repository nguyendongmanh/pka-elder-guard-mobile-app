import 'package:elder_guard_app/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class HomeBottomActionBar extends StatelessWidget {
  const HomeBottomActionBar({
    required this.items,
    required this.currentIndex,
    required this.visibleLabelIndex,
    required this.onTap,
    super.key,
  });

  final List<HomeBottomBarItemData> items;
  final int currentIndex;
  final int? visibleLabelIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.94),
      elevation: 16,
      shadowColor: AppColors.deepTeal.withValues(alpha: 0.18),
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Row(
          children: [
            for (var index = 0; index < items.length; index++)
              Expanded(
                child: _BottomActionItem(
                  data: items[index],
                  isSelected: currentIndex == index,
                  showLabel: visibleLabelIndex == index,
                  onTap: () => onTap(index),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class HomeBottomBarItemData {
  const HomeBottomBarItemData({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

class _BottomActionItem extends StatelessWidget {
  const _BottomActionItem({
    required this.data,
    required this.isSelected,
    required this.showLabel,
    required this.onTap,
  });

  final HomeBottomBarItemData data;
  final bool isSelected;
  final bool showLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foregroundColor =
        isSelected ? AppColors.tealPrimary : AppColors.tealMist;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? data.selectedIcon : data.icon,
              size: 31,
              color: foregroundColor,
            ),
            const SizedBox(height: 4),
            SizedBox(
              height: 16,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child:
                    showLabel
                        ? Text(
                          data.label,
                          key: ValueKey(data.label),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(
                            context,
                          ).textTheme.labelSmall?.copyWith(
                            color: foregroundColor,
                            fontWeight: FontWeight.w800,
                          ),
                        )
                        : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
